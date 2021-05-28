Feature: Da Negociação Ao Cancelamento do Pedido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario: Negociar e Cancelar Pedido com sucesso
        Given path "/process-definition/key/DaNegociacaoAEntregaDoPedidoProcess/start"
        Given request
        """
        {
            "variables": {
                "quantidadePedida": {"value": 1001, "type": "Integer"},
                "prazoPedido": {"value": 0, "type": "Integer"},
                "nomeCliente": {"value": "Maria", "type": "String"},
                "indicacao": {"value": true, "type": "Boolean"},
                "comprou": {"value": true, "type": "Boolean"},
                "pagou": {"value": true, "type": "Boolean"}
            },
	        "withVariablesInReturn": true
        }
        """
        When method POST
        Then status 200
        And match $ == '#object'
        And match $.id == '#present'
        And match $.variables.numeroPedido.value == '#present'
        And match $.variables.pedidoValido.value == false
        * def idInstancia = $.id
        * def numeroPedido = $.variables.numeroPedido.value
        * print 'idInstancia: ' + idInstancia
        * print 'numeroPedido: ' + numeroPedido

        Given path "/task?processVariables=numeroPedido_eq_" + numeroPedido
        When method GET
        Then status 200
        And match $ == '#array'
        And match $[0].id == '#present'
        And match $[0].taskDefinitionKey == 'InformarPedidoCanceladoTask'
        * def idTask = $[0].id   

        Given path "/task/" + idTask + "/complete"
        And header Content-Type = 'application/json'
        When method POST
        Then status 204

        Given path "/history/process-instance/" + idInstancia
        When method GET
        Then status 200
        And match $ == '#object'
        And match $.state == 'COMPLETED'
