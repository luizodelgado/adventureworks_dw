{{ config(materialized='table') }}

with
    staging_country as (
        select *
        from {{ref('stg_sap__countryregion')}}
    )

    , transformed_country as (
        select
            row_number() over (order by countryregioncode) as countryregioncode_sk -- auto-incremental surrogate key
            , countryregioncode
            , name as country_name
        from staging_country
    )
    
    ,   staging_state as (
        select *
        from {{ref('stg_sap__stateprovince')}}
    )

    , transformed_state as (
        select
            row_number() over (order by stateprovinceid) as stateprovinceid_sk -- auto-incremental surrogate key
            , stateprovinceid
            , stateprovincecode
            , countryregioncode
            , isonlystateprovinceflag
            , name as stateprovince_name
            , territoryid
        from staging_state
    )

    ,   staging_address as (
        select *
        from {{ref('stg_sap__address')}}
    )
    , transformed_address as (
        select
            row_number() over (order by addressid) as addressid_sk -- auto-incremental surrogate key
            , addressid
            , addressline1
            , addressline2
            , city
            , stateprovinceid
            , postalcode
            , spatiallocation
        from staging_address
    )

    , join_city_state as (
        select
            *
        from
            transformed_address
        left join transformed_state
        on transformed_address.stateprovinceid = transformed_state.stateprovinceid
    )

    select
        addressid_sk
        , addressid
        , addressline1
        , addressline2        
        , city
        , postalcode
        , spatiallocation
        , stateprovincecode
        , isonlystateprovinceflag
        , stateprovince_name
        , country_name

    from
        join_city_state
    left join transformed_country
    on join_city_state.countryregioncode = transformed_country.countryregioncode
        