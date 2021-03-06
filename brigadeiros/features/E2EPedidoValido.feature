Feature: Registrar Pedido Válido E2E

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario: Registrar Pedido Válido ponta a ponta 
        Given path "/process-definition/key/DaNegociacaoAEntregaDoPedidoProcess/start"
        Given request
        """
        {
            "variables": {
                "quantidadePedida": {"value": 100, "type": "Integer"},
                "prazoPedido": {"value": 1, "type": "Integer"},
                "nomeCliente": {"value": "Creusa", "type": "String"},
                "indicacao": {"value": true, "type": "Boolean"},
                "comprou": {"value": true, "type": "Boolean"},
                "pagou": {"value": true, "type": "Boolean"}
            },
	        "withVariablesInReturn": true
        }
        """
        When method POST
        Then status 200
        And match $.variables.numeroPedido.value == '#present'
        And match $.variables.pedidoValido.value == true
        And match $.variables.msgValidacaoPedido.value == "Pedido de cliente vip"
        And match $.id == '#present'
        * def idInstance = $.id
        * def numeroPedido = $.variables.numeroPedido.value
        * print 'idInstance: ' + idInstance
        * print 'numeroPedido: ' + numeroPedido

        Given param processVariables = "numeroPedido_eq_" + numeroPedido
        Given path "/task"
        When method GET
        Then status 200
        And match $[0].id == '#present'
        And match $[0].taskDefinitionKey == 'InformarPedidoAceitoTask'
        * def idTask = $[0].id   

        Given path "/task/" + idTask + "/complete"
        And header Content-Type = 'application/json'
        When method POST
        Then status 204

        Given param processVariables = "numeroPedido_eq_" + numeroPedido
        Given path "/task"
        When method GET
        Then status 200
        And match $[0].id == '#present'
        And match $[0].taskDefinitionKey == 'FabricarPedidoTask'
        * def idTask = $[0].id   

        Given path "/task/" + idTask + "/complete"
        And header Content-Type = 'application/json'
        When method POST
        Then status 204

        Given param processVariables = "numeroPedido_eq_" + numeroPedido
        Given path "/task"
        When method GET
        Then status 200
        And match $[0].id == '#present'
        And match $[0].taskDefinitionKey == 'EntregarPedidoTask'
        * def idTask = $[0].id   

        Given path "/task/" + idTask + "/complete"
        And header Content-Type = 'application/json'
        When method POST
        Then status 204

        Given path "/history/process-instance/" + idInstance
        When method GET
        Then status 200
        And match $.state == 'COMPLETED'
