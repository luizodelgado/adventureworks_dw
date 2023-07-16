with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            salesorderid
            , salesorderdetailid
            , carriertrackingnumber
            , orderqty
            , productid
            , specialofferid
            , unitprice
            , unitpricediscount
        from {{  source('sap','salesorderdetail')  }}
    )

    select * from source_data