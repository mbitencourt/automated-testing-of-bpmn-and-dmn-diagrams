Feature: Avaliar Pedido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario Outline: Avaliar Pedidos com sucesso 
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
        And match $[0].pedidoValido.value == <pedidoValido>
        And match $[0].msgValidacaoPedido.value == <msgValidacaoPedido>

        Examples: Pedidos válidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        |
            |               99 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |              100 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |             1000 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |             1001 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |               99 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |              100 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |             1000 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |             1001 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |
            |              100 |           1 | Maria       | true      | false   | false | true         | "Pedido de cliente comum" |
            |             1000 |           1 | Maria       | true      | false   | false | true         | "Pedido de cliente comum" |
            |              100 |           1 | Maria       | false     | true    | true  | true         | "Pedido de cliente comum" |
            |             1000 |           1 | Maria       | false     | true    | true  | true         | "Pedido de cliente comum" |
           
        Examples: Pedidos inválidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        |
            |              100 |           0 | Penna       | true      | true    | true  | false        | "Pedido não vale a pena"  |
            |             1000 |           0 | Penna       | true      | true    | true  | false        | "Pedido não vale a pena"  |
            |               99 |           1 | Penna       | true      | true    | true  | false        | "Pedido não vale a pena"  |
            |             1001 |           1 | Penna       | true      | true    | true  | false        | "Pedido não vale a pena"  |
            |              100 |           1 | Frias       | true      | true    | false | false        | "Pedido de cliente ruim"  |
            |              100 |           1 | Frias       | false     | true    | false | false        | "Pedido de cliente ruim"  |
            |              100 |           1 | Frias       | false     | false   | false | false        | "Pedido de cliente ruim"  |
