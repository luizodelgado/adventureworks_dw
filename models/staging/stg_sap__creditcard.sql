with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            creditcardid
            , cardtype
            , cardnumber
            , expmonth
            , expyear
        from {{  source('sap','creditcard')  }}
    )

    select * from source_data