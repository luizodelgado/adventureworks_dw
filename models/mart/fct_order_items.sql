{{ config(materialized='table') }}

with
    production_product_with_sk as (
        select
            productid_sk
            , productid
        from {{  ref('dim_products')  }}
    )

    , order_dates as (
        select
            salesorderid
            , orderdate
            , duedate
            , shipdate
        from {{  ref('stg_sap__salesorderheader')  }}
    )

    , sales_salesorderdetail_with_fk as (
        select
            sales_salesorderdetail.salesorderid
            , order_dates.orderdate
            , order_dates.duedate
            , order_dates.shipdate
            , sales_salesorderdetail.carriertrackingnumber
            , sales_salesorderdetail.salesorderdetailid
            , sales_salesorderdetail.orderqty
            , production_product_with_sk.productid_sk as productid_fk
            , sales_salesorderdetail.specialofferid
            , sales_salesorderdetail.unitprice
            , sales_salesorderdetail.unitpricediscount
        from {{  ref('stg_sap__salesorderdetail')  }} sales_salesorderdetail
        left join production_product_with_sk
        on sales_salesorderdetail.productid = production_product_with_sk.productid
        left join order_dates
        on sales_salesorderdetail.salesorderid = order_dates.salesorderid
    )

    , add_total as (
        select
            *
            , orderqty*unitprice as fullprice
            , orderqty*unitprice*unitpricediscount as discountapplied
            , (orderqty*unitprice)-(orderqty*unitprice*unitpricediscount) as total
        from sales_salesorderdetail_with_fk
    )

    select * from add_total