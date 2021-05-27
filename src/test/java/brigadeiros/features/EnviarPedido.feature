Feature: Enviar Pedido

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario Outline: Enviar Pedidos
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
        And match $.variables.pedidoValido.value == <pedidoValido>
        And match $.variables.msgValidacaoPedido.value == <msgValidacaoPedido>
        And match $.variables.valorPedido.value == <valorPedido>

        Examples: Pedidos válidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | numeroPedido | pedidoValido | msgValidacaoPedido       | valorPedido   |
            | 99               | 0           | Creusa      | false     | false   | false | '#number'    | true         | "Pedido aceito"          |        128.70 |
            | 100              | 1           | Creusa      | true      | true    | true  | '#number'    | true         | "Pedido aceito"          |        130.00 |
            | 100              | 1           | Maria       | false     | true    | true  | '#number'    | true         | "Pedido aceito"          |        160.00 |
            | 100              | 1           | Maria       | true      | false   | false | '#number'    | true         | "Pedido aceito"          |        160.00 |

        Examples: Pedidos inválidos
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | numeroPedido | pedidoValido | msgValidacaoPedido       | valorPedido   |
            | 99               | 1           | Maria       | true      | true    | true  | '#number'    | false        | "Pedido não vale a pena" | '#notpresent' |
            | 1001             | 1           | Maria       | true      | true    | true  | '#number'    | false        | "Pedido não vale a pena" | '#notpresent' |
            | 100              | 0           | Maria       | true      | true    | true  | '#number'    | false        | "Pedido não vale a pena" | '#notpresent' |
            | 100              | 1           | Maria       | true      | true    | false | '#number'    | false        | "Pedido de cliente ruim" | '#notpresent' |
            | 100              | 1           | Maria       | false     | false   | false | '#number'    | false        | "Pedido de cliente ruim" | '#notpresent' |
