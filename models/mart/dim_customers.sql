{{ config(materialized='table') }}

with
    staging as (
        select *
        from {{ref('stg_sap__customer')}}
    )
    , transformed as (
        select
            row_number() over (order by customerid) as customerid_sk -- auto-incremental surrogate key
            , customerid
            , personid
            , storeid
            , territoryid
        from staging
    )

    select * from transformed