Feature: Avaliar Pedido Válido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario Outline: Avaliar Pedidos válidos e inválidos 
        Given path "/decision-definition/key/PedidoValidoDecision/evaluate"
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
        And match $ == '#array'
        And match response[0].pedidoValido.value == <pedidoValido>
        And match response[0].msgValidacaoPedido.value == <msgValidacaoPedido>

        Examples: Pedidos válidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido       |
            |               99 |           0 | Creusa      | false     | false   | false | true         | "Pedido aceito"          |
            |               99 |           1 | Creusa      | false     | false   | false | true         | "Pedido aceito"          |
            |              100 |           0 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |
            |              100 |           1 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |
            |              999 |           0 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |
            |              999 |           1 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |
            |             1001 |           0 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |
            |             1001 |           1 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |
            |              100 |           1 | Maria       | false     | true    | true  | true         | "Pedido aceito"          |
            |              100 |           1 | Maria       | true      | false   | false | true         | "Pedido aceito"          |
            |              999 |           1 | Maria       | false     | true    | true  | true         | "Pedido aceito"          |
            |              999 |           1 | Maria       | true      | false   | false | true         | "Pedido aceito"          |

        Examples: Pedidos inválidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido       |
            |              100 |           0 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" |
            |              999 |           0 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" |
            |               99 |           1 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" |
            |             1001 |           1 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" |
            |              100 |           1 | Maria       | true      | true    | false | false        | "Pedido de cliente ruim" |
            |              100 |           1 | Maria       | false     | false   | false | false        | "Pedido de cliente ruim" |
