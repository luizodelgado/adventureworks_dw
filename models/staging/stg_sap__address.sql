with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            addressid
            , addressline1
            , addressline2
            , city
            , stateprovinceid
            , postalcode
            , spatiallocation
        from {{  source('sap','address')  }}
    )

    select * from source_data