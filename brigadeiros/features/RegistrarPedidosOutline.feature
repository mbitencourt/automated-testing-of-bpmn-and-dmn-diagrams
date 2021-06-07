Feature: Registrar Pedidos

    Background:
        Given url "http://localhost:8080/engine-rest"
    
    Scenario Outline: Registrar Pedidos com sucesso
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
        And match $.variables.valorPedido.value == <valorPedido>
        And match $.variables.pedidoValido.value == <pedidoValido>
        And match $.variables.msgValidacaoPedido.value == <msgValidacaoPedido>
        And match $.variables.numeroPedido.value == '#present'
        
        Examples: Pedidos de cliente vip
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        | valorPedido   |
            |               99 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |        128.70 |
            |              100 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |        130.00 |
            |              999 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1298.70 |
            |             1001 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1301.30 |
            |               99 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |        128.70 |
            |              100 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |        130.00 |
            |              999 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1298.70 |
            |             1001 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1301.30 |

        Examples: Pedidos de cliente comum
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        | valorPedido   |
            |              100 |           1 | Maria       | true      | false   | false | true         | "Pedido de cliente comum" |        160.00 |
            |              999 |           1 | Maria       | true      | false   | false | true         | "Pedido de cliente comum" |       1598.40 |
            |              100 |           1 | Maria       | false     | true    | true  | true         | "Pedido de cliente comum" |        160.00 |
            |              999 |           1 | Maria       | false     | true    | true  | true         | "Pedido de cliente comum" |       1598.40 |

        Examples: Pedidos que não valem a pena
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        | valorPedido   |
            |              100 |           0 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena"  | '#notpresent' |
            |              999 |           0 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena"  | '#notpresent' |
            |               99 |           1 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena"  | '#notpresent' |
            |             1001 |           1 | Maria       | true      | true    | true  | false        | "Pedido não vale a pena"  | '#notpresent' |

        Examples: Pedidos de cliente ruim
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        | valorPedido   |
            |              100 |           1 | Maria       | true      | true    | false | false        | "Pedido de cliente ruim"  | '#notpresent' |
            |              100 |           1 | Maria       | false     | true    | false | false        | "Pedido de cliente ruim"  | '#notpresent' |
            |              100 |           1 | Maria       | false     | false   | false | false        | "Pedido de cliente ruim"  | '#notpresent' |
