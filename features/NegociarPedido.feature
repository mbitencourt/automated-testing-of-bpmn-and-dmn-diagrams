Feature: Negociar Pedido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario Outline: Negociar Pedido com sucesso
        Given path "/process-definition/key/DaNegociacaoAEntregaDoPedidoProcess/start"
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
            },
	        "withVariablesInReturn": true
        }
        """
        When method POST
        Then status 200
        And match $ == '#object'
        And match $.variables.numeroPedido.value == '#present'
        And match $.variables.valorPedido.value == <valorPedido>
        And match $.variables.pedidoValido.value == <pedidoValido>
        And match $.variables.msgValidacaoPedido.value == <msgValidacaoPedido>
        
        Examples: Pedidos válidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido       | valorPedido   |
            |               99 |           0 | Creusa      | false     | false   | false | true         | "Pedido aceito"          |        128.70 |
            |              100 |           0 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |        130.00 |
            |              999 |           0 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |       1298.70 |
            |             1001 |           0 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |       1301.30 |
            |               99 |           1 | Creusa      | false     | false   | false | true         | "Pedido aceito"          |        128.70 |
            |              100 |           1 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |        130.00 |
            |              999 |           1 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |       1298.70 |
            |             1001 |           1 | Creusa      | true      | true    | true  | true         | "Pedido aceito"          |       1301.30 |
            |              100 |           1 | Maria       | false     | true    | true  | true         | "Pedido aceito"          |        160.00 |
            |              100 |           1 | Maria       | true      | false   | false | true         | "Pedido aceito"          |        160.00 |
            |              999 |           1 | Maria       | false     | true    | true  | true         | "Pedido aceito"          |       1598.40 |
            |              999 |           1 | Maria       | true      | false   | false | true         | "Pedido aceito"          |       1598.40 |

        Examples: Pedidos inválidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido       | valorPedido   |
            |              100 |           0 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" | '#notpresent' |
            |              999 |           0 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" | '#notpresent' |
            |               99 |           1 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" | '#notpresent' |
            |             1001 |           1 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena" | '#notpresent' |
            |              100 |           1 | Maria       | true      | true    | false | false        | "Pedido de cliente ruim" | '#notpresent' |
            |              100 |           1 | Maria       | false     | false   | false | false        | "Pedido de cliente ruim" | '#notpresent' |
