{{ config(materialized='table') }}

with
    sales_customer_with_sk as (
        select
            customerid_sk
            , customerid
        from {{  ref('dim_customers')  }}
    )

    , sales_creditcard_with_sk as (
        select
            creditcardid_sk
            , creditcardid
        from {{  ref('dim_creditcards')  }}
    )

    , person_address_with_sk as (
        select
            addressid_sk
            , addressid
            , stateprovinceid
        from {{  ref('dim_addresses')  }}
    )

    , person_stateprovince_with_sk as (
        select
            stateprovinceid_sk
            , stateprovinceid
            , countryregioncode
        from {{  ref('dim_stateprovinces')  }}
    )  

    , person_countryregion_with_sk as (
        select
            countryregioncode_sk
            , countryregioncode
        from {{  ref('dim_countryregions')  }}
    )

    , quantity as (
        select
            sales_salesorderdetail.salesorderid
            , sum(sales_salesorderdetail.orderqty) as quantity
        from {{  ref('stg_sap__salesorderdetail')  }} sales_salesorderdetail
        group by 1
    )

    , sales_salesorderheader_with_fk as (
        select
            sales_salesorderheader.salesorderid
            , sales_salesorderheader.revisionnumber
            , sales_salesorderheader.orderdate
            , sales_salesorderheader.duedate
            , sales_salesorderheader.shipdate
            , sales_salesorderheader.status
            , sales_salesorderheader.onlineorderflag
            , sales_salesorderheader.purchaseordernumber
            , sales_salesorderheader.accountnumber
            , sales_customer_with_sk.customerid_sk as customerid_fk
            , sales_salesorderheader.salespersonid
            , sales_salesorderheader.billtoaddressid -- endereço de cobrança
            , sales_salesorderheader.shiptoaddressid -- endereço de entrega, DePara com addressid
            , person_address_with_sk.addressid_sk as addressid_fk
            , person_stateprovince_with_sk.stateprovinceid_sk as stateprovinceid_fk
            , person_countryregion_with_sk.countryregioncode_sk as countryregioncode_fk
            , sales_salesorderheader.territoryid
            , sales_salesorderheader.shipmethodid
            , sales_creditcard_with_sk.creditcardid_sk as creditcardid_fk
            , sales_salesorderheader.creditcardapprovalcode
            , sales_salesorderheader.currencyrateid
            , quantity.quantity
            , sales_salesorderheader.subtotal
            , sales_salesorderheader.taxamt
            , sales_salesorderheader.freight
            , sales_salesorderheader.totaldue
            , sales_salesorderheader.comment
        from {{  ref('stg_sap__salesorderheader')  }} sales_salesorderheader
        left join sales_customer_with_sk
        on sales_salesorderheader.customerid = sales_customer_with_sk.customerid
        left join sales_creditcard_with_sk
        on sales_salesorderheader.creditcardid = sales_creditcard_with_sk.creditcardid
        left join person_address_with_sk
        on sales_salesorderheader.shiptoaddressid = person_address_with_sk.addressid
        left join person_stateprovince_with_sk
        on person_address_with_sk.stateprovinceid = person_stateprovince_with_sk.stateprovinceid
        left join person_countryregion_with_sk
        on person_stateprovince_with_sk.countryregioncode = person_countryregion_with_sk.countryregioncode
        left join quantity
        on sales_salesorderheader.salesorderid = quantity.salesorderid
    )

    select * from sales_salesorderheader_with_fk