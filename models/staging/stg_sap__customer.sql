with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            customerid
            , personid
            , storeid
            , territoryid
        from {{  source('sap','customer')  }}
    )

    select * from source_data