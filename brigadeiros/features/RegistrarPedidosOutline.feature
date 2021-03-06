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
            |             1000 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1300.00 |
            |             1001 |           0 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1301.30 |
            |               99 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |        128.70 |
            |              100 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |        130.00 |
            |             1000 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1300.00 |
            |             1001 |           1 | Creusa      | false     | false   | false | true         | "Pedido de cliente vip"   |       1301.30 |

        Examples: Pedidos de cliente comum
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        | valorPedido   |
            |              100 |           1 | Maria       | true      | false   | false | true         | "Pedido de cliente comum" |        160.00 |
            |             1000 |           1 | Maria       | true      | false   | false | true         | "Pedido de cliente comum" |       1600.00 |
            |              100 |           1 | Maria       | false     | true    | true  | true         | "Pedido de cliente comum" |        160.00 |
            |             1000 |           1 | Maria       | false     | true    | true  | true         | "Pedido de cliente comum" |       1600.00 |

        Examples: Pedidos que n??o valem a pena
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        | valorPedido   |
            |              100 |           0 | Penna       | true      | true    | true  | false        | "Pedido n??o vale a pena"  | '#notpresent' |
            |             1000 |           0 | Penna       | true      | true    | true  | false        | "Pedido n??o vale a pena"  | '#notpresent' |
            |               99 |           1 | Penna       | true      | true    | true  | false        | "Pedido n??o vale a pena"  | '#notpresent' |
            |             1001 |           1 | Penna       | true      | true    | true  | false        | "Pedido n??o vale a pena"  | '#notpresent' |

        Examples: Pedidos de cliente ruim
            | quantidadePedida | prazoPedido | nomeCliente | indicacao | comprou | pagou | pedidoValido | msgValidacaoPedido        | valorPedido   |
            |              100 |           1 | Frias       | true      | true    | false | false        | "Pedido de cliente ruim"  | '#notpresent' |
            |              100 |           1 | Frias       | false     | true    | false | false        | "Pedido de cliente ruim"  | '#notpresent' |
            |              100 |           1 | Frias       | false     | false   | false | false        | "Pedido de cliente ruim"  | '#notpresent' |
