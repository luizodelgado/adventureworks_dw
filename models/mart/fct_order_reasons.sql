{{ config(materialized='table') }}

with
    sales_salesreason_with_sk as (
        select
            salesreasonid_sk
            , salesreasonid
        from {{  ref('dim_salesreasons')  }}
    )

    , sales_salesorderheadersalesreason_with_fk as (
        select
            sales_salesorderheadersalesreason.salesorderid
            , sales_salesreason_with_sk.salesreasonid_sk as salesreasonid_fk
        from {{  ref('stg_sap__salesorderheadersalesreason')  }} sales_salesorderheadersalesreason
        left join sales_salesreason_with_sk
        on sales_salesorderheadersalesreason.salesreasonid = sales_salesreason_with_sk.salesreasonid
    )

    select * from sales_salesorderheadersalesreason_with_fk