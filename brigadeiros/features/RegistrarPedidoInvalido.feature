Feature: Registrar Pedido Inválido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario: Registrar Pedido Inválido que não vale a pena
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
        And match $.variables.numeroPedido.value == '#present'
        And match $.variables.pedidoValido.value == false
        And match $.variables.msgValidacaoPedido.value == "Pedido não vale a pena"

    Scenario: Registrar Pedido Inválido de cliente ruim
        Given path "/process-definition/key/DaNegociacaoAEntregaDoPedidoProcess/start"
        Given request
        """
        {
            "variables": {
                "quantidadePedida": {"value": 100, "type": "Integer"},
                "prazoPedido": {"value": 1, "type": "Integer"},
                "nomeCliente": {"value": "Maria", "type": "String"},
                "indicacao": {"value": false, "type": "Boolean"},
                "comprou": {"value": true, "type": "Boolean"},
                "pagou": {"value": false, "type": "Boolean"}
            },
	        "withVariablesInReturn": true
        }
        """
        When method POST
        Then status 200
        And match $.variables.numeroPedido.value == '#present'
        And match $.variables.pedidoValido.value == false
        And match $.variables.msgValidacaoPedido.value == "Pedido de cliente ruim"