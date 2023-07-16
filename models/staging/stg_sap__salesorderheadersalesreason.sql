with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            salesorderid
            , salesreasonid
        from {{  source('sap','salesorderheadersalesreason')  }}
    )

    select * from source_data