{{ config(materialized='table') }}

with
    production_product_with_sk as (
        select
            productid_sk
            , productid
        from {{  ref('dim_product')  }}
    )

    , sales_salesorderdetail_with_fk as (
        select
            sales_salesorderdetail.salesorderid
            , sales_salesorderdetail.salesorderdetailid
            , sales_salesorderdetail.carriertrackingnumber
            , sales_salesorderdetail.orderqty
            , production_product_with_sk.productid_sk as productid_fk
            , sales_salesorderdetail.specialofferid
            , sales_salesorderdetail.unitprice
            , sales_salesorderdetail.unitpricediscount
        from {{  ref('stg_sap__salesorderdetail')  }} sales_salesorderdetail
        left join production_product_with_sk
        on sales_salesorderdetail.productid = production_product_with_sk.productid
    )

    select * from sales_salesorderdetail_with_fk