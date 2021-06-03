Feature: Registrar Pedido Válido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario: Registrar Pedido Válido aceito
        
        
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
        And match $.variables.msgValidacaoPedido.value == "Pedido aceito"
