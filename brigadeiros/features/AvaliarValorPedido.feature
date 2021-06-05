Feature: Avaliar Valor do Pedido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario Outline: Avaliar Valor do Pedido com sucesso
        Given path "/decision-definition/key/ValorPedidoDecision/evaluate"
        Given request
        """
        {
            "variables": {
                "quantidadePedida": {"value": <quantidadePedida>, "type": "Integer"},
                "prazoPedido": {"value": 1, "type": "Integer"},
                "nomeCliente": {"value": <nomeCliente>, "type": "String"},
                "indicacao": {"value": true, "type": "Boolean"},
                "comprou": {"value": true, "type": "Boolean"},
                "pagou": {"value": true, "type": "Boolean"}
            }
        }
        """
        When method POST
        Then status 200
        And match response[0].valorPedido.value == <valorPedido>

        Examples: Pedidos válidos
            | nomeCliente | quantidadePedida | valorPedido |
            | Creusa      |              100 |      130.00 |
            | Maria       |              100 |      160.00 |
