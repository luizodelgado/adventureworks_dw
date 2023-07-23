with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            salesreasonid	
            , name	
            , reasontype	
        from {{  source('sap','salesreason')  }}
    )

    select * from source_data