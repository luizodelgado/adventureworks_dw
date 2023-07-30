with 
    source_data as (
        select --selecionar primeiros as keys e em uma ordem que faça sentido
            salesorderid
            , revisionnumber
            , cast(left(orderdate, 10) as date) as orderdate
            , cast(left(duedate, 10) as date) as duedate
            , cast(left(shipdate, 10) as date) as shipdate
            , status
            , onlineorderflag
            , purchaseordernumber
            , accountnumber
            , customerid
            , salespersonid
            , territoryid
            , billtoaddressid
            , shiptoaddressid
            , shipmethodid
            , creditcardid
            , creditcardapprovalcode
            , currencyrateid
            , subtotal
            , taxamt
            , freight
            , totaldue
            , comment
        from {{  source('sap','salesorderheader')  }}
    )

    select * from source_data