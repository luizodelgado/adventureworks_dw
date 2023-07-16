with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            countryregioncode
            , name
        from {{  source('sap','countryregion')  }}
    )

    select * from source_data