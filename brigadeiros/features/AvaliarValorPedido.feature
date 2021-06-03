Feature: Avaliar Pedido Válido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario Outline: Avaliar Pedidos válidos e inválidos 
        Given path "/decision-definition/key/ValorPedidoDecision/evaluate"
        Given request
        """
        {
            "variables": {
                "quantidadePedida": {"value": <quantidadePedida>, "type": "Integer"},
                "prazoPedido": {"value": <prazoPedido>, "type": "Integer"},
                "nomeCliente": {"value": <nomeCliente>, "type": "String"},
                "indicacao": {"value": <indicacao>, "type": "Boolean"},
                "comprou": {"value": <comprou>, "type": "Boolean"},
                "pagou": {"value": <pagou>, "type": "Boolean"}
            }
        }
        """
        When method POST
        Then status 200
        And match response[0].valorPedido.value == <valorPedido>

        Examples: Pedidos válidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | valorPedido |
            |               99 |           0 | Creusa      | false     | false   | false |      128.70 |
            |              100 |           0 | Creusa      | true      | true    | true  |      130.00 |
            |              999 |           0 | Creusa      | true      | true    | true  |     1298.70 |
            |             1001 |           0 | Creusa      | true      | true    | true  |     1301.30 |
            |               99 |           1 | Creusa      | false     | false   | false |      128.70 |
            |              100 |           1 | Creusa      | true      | true    | true  |      130.00 |
            |              999 |           1 | Creusa      | true      | true    | true  |     1298.70 |
            |             1001 |           1 | Creusa      | true      | true    | true  |     1301.30 |
            |              100 |           1 | Maria       | false     | true    | true  |      160.00 |
            |              100 |           1 | Maria       | true      | false   | false |      160.00 |
            |              999 |           1 | Maria       | false     | true    | true  |     1598.40 |
            |              999 |           1 | Maria       | true      | false   | false |     1598.40 |