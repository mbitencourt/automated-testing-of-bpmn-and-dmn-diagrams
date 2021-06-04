Feature: Registrar Pedido

    Background:
        Given url "http://localhost:8080/engine-rest/process-definition/key/DaNegociacaoAEntregaDoPedidoProcess/start"
    
    Scenario: Registrar Pedido aceito
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
        And match $.variables.pedidoValido.value == true
        And match $.variables.msgValidacaoPedido.value == "Pedido aceito"
        And match $.variables.numeroPedido.value == '#present'

    Scenario: Registrar Pedido que não vale a pena
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
        And match $.variables.pedidoValido.value == false
        And match $.variables.msgValidacaoPedido.value == "Pedido não vale a pena"
        And match $.variables.numeroPedido.value == '#present'

    Scenario: Registrar Pedido de cliente ruim
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
        And match $.variables.pedidoValido.value == false
        And match $.variables.msgValidacaoPedido.value == "Pedido de cliente ruim"
        And match $.variables.numeroPedido.value == '#present'
