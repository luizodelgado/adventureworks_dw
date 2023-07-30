{{ config(materialized='table') }}

with
    staging as (
        select *
        from {{ref('stg_sap__salesreason')}}
    )
    , transformed as (
        select
            row_number() over (order by salesreasonid) as salesreasonid_sk -- auto-incremental surrogate key
            , salesreasonid	
            , name	
            , reasontype	
            --, modifieddate
        from staging
    )

    select * from transformed