--
-- PostgreSQL database dump
--

\restrict YISZ8HdWwnvgTabzXaS7yGEIFVfqEFKen1pUB0vfTBq9ELK75xZJ1jgerTtRg4O

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO postgres;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: attribute_data_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attribute_data_type_enum AS ENUM (
    'string',
    'number',
    'boolean',
    'date',
    'enum'
);


ALTER TYPE public.attribute_data_type_enum OWNER TO postgres;

--
-- Name: bom_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.bom_status_enum AS ENUM (
    'draft',
    'active',
    'archived'
);


ALTER TYPE public.bom_status_enum OWNER TO postgres;

--
-- Name: color_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.color_status_enum AS ENUM (
    'active',
    'inactive'
);


ALTER TYPE public.color_status_enum OWNER TO postgres;

--
-- Name: entity_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.entity_type_enum AS ENUM (
    'season',
    'product',
    'material',
    'supplier',
    'color'
);


ALTER TYPE public.entity_type_enum OWNER TO postgres;

--
-- Name: material_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.material_status_enum AS ENUM (
    'in_development',
    'active',
    'dropped',
    'rfq'
);


ALTER TYPE public.material_status_enum OWNER TO postgres;

--
-- Name: product_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.product_status_enum AS ENUM (
    'development',
    'pre-production',
    'production',
    'inactive',
    'delisting'
);


ALTER TYPE public.product_status_enum OWNER TO postgres;

--
-- Name: season_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.season_status_enum AS ENUM (
    'planned',
    'active',
    'archived'
);


ALTER TYPE public.season_status_enum OWNER TO postgres;

--
-- Name: supplier_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.supplier_status_enum AS ENUM (
    'active',
    'inactive'
);


ALTER TYPE public.supplier_status_enum OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: get_enum_values(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_enum_values(p_enum_type character varying) RETURNS TABLE(enum_value character varying, label character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT e.enum_value, e.label
  FROM enums e
  WHERE e.enum_type = p_enum_type
    AND e.is_active = TRUE
  ORDER BY e.order_index, e.enum_value;
END;
$$;


ALTER FUNCTION public.get_enum_values(p_enum_type character varying) OWNER TO postgres;

--
-- Name: FUNCTION get_enum_values(p_enum_type character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.get_enum_values(p_enum_type character varying) IS '获取指定类型的所有活跃枚举值';


--
-- Name: get_latest_version_id(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_latest_version_id(p_table_name text, p_code_field text, p_code_value text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  v_id UUID;
  v_query TEXT;
BEGIN
  v_query := format(
    'SELECT id FROM %I WHERE %I = $1 AND is_latest = TRUE LIMIT 1',
    p_table_name,
    p_code_field
  );

  EXECUTE v_query INTO v_id USING p_code_value;

  RETURN v_id;
END;
$_$;


ALTER FUNCTION public.get_latest_version_id(p_table_name text, p_code_field text, p_code_value text) OWNER TO postgres;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.users (id, email, display_name, is_admin, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),
    FALSE,
    NOW(),
    NOW()
  );
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: update_enums_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_enums_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_enums_updated_at() OWNER TO postgres;

--
-- Name: update_master_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_master_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_master_updated_at() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


ALTER FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_update_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_level_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.prefixes_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0,
    broadcast_adapter character varying(255) DEFAULT 'gen_rpc'::character varying,
    max_presence_events_per_second integer DEFAULT 1000,
    max_payload_size_in_kb integer DEFAULT 3000
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: attribute_definitions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attribute_definitions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    entity_type public.entity_type_enum NOT NULL,
    key character varying(100) NOT NULL,
    label character varying(255) NOT NULL,
    data_type public.attribute_data_type_enum NOT NULL,
    required boolean DEFAULT false NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    options jsonb,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.attribute_definitions OWNER TO postgres;

--
-- Name: bom_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bom_items (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bom_id uuid NOT NULL,
    line_number integer NOT NULL,
    material_id uuid NOT NULL,
    color_id uuid,
    supplier_id uuid,
    quantity numeric(12,4) NOT NULL,
    unit character varying(50) NOT NULL,
    attributes jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.bom_items OWNER TO postgres;

--
-- Name: colors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.colors (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    color_code character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    rgb_hex character varying(7),
    status text DEFAULT 'active'::public.color_status_enum NOT NULL,
    type_id uuid,
    attributes jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    create_by text,
    update_by text
);


ALTER TABLE public.colors OWNER TO postgres;

--
-- Name: COLUMN colors.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.colors.status IS 'Status of the color. Valid values are managed in the enums table (enum_type=color_status)';


--
-- Name: entity_type_nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_type_nodes (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    entity_type public.entity_type_enum NOT NULL,
    parent_id uuid,
    name character varying(255) NOT NULL,
    code character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.entity_type_nodes OWNER TO postgres;

--
-- Name: enums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enums (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    enum_type character varying(50) NOT NULL,
    enum_value character varying(100) NOT NULL,
    label character varying(255) NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.enums OWNER TO postgres;

--
-- Name: TABLE enums; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.enums IS '系统枚举值管理表，用于动态管理各种状态和选项';


--
-- Name: material_colors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material_colors (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    material_id uuid NOT NULL,
    color_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.material_colors OWNER TO postgres;

--
-- Name: material_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material_master (
    material_code character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.material_master OWNER TO postgres;

--
-- Name: TABLE material_master; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.material_master IS 'Master table for materials. Each material_code appears exactly once. Contains item identity and creation metadata.';


--
-- Name: COLUMN material_master.material_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.material_master.material_code IS 'Unique material identifier. Primary key. Referenced by materials table versions.';


--
-- Name: material_suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material_suppliers (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    material_id uuid NOT NULL,
    supplier_id uuid NOT NULL,
    price numeric(12,2),
    currency character varying(10) DEFAULT 'USD'::character varying,
    attributes jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.material_suppliers OWNER TO postgres;

--
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    material_code character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    status text DEFAULT 'in_development'::public.material_status_enum NOT NULL,
    type_id uuid,
    attributes jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    version character(1) DEFAULT 'A'::bpchar NOT NULL,
    iteration smallint DEFAULT 1 NOT NULL,
    create_by text,
    update_by text,
    is_latest boolean DEFAULT true NOT NULL,
    CONSTRAINT materials_iteration_check CHECK (((iteration >= 1) AND (iteration <= 999))),
    CONSTRAINT materials_version_check CHECK ((version ~ '^[A-Z]$'::text))
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- Name: COLUMN materials.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.materials.status IS 'Status of the material. Valid values are managed in the enums table (enum_type=material_status)';


--
-- Name: COLUMN materials.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.materials.version IS 'Major version letter (A-Z). Currently only A is used.';


--
-- Name: COLUMN materials.iteration; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.materials.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)';


--
-- Name: COLUMN materials.is_latest; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.materials.is_latest IS 'Indicates if this is the current/latest version of the material. Only one version per material_code can be latest.';


--
-- Name: materials_latest; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.materials_latest AS
 SELECT m.id,
    m.material_code,
    m.name,
    m.status,
    m.type_id,
    m.attributes,
    m.created_at,
    m.updated_at,
    m.version,
    m.iteration,
    m.create_by,
    m.update_by,
    m.is_latest,
    mm.created_at AS master_created_at,
    mm.created_by AS master_created_by
   FROM (public.material_master mm
     JOIN public.materials m ON (((mm.material_code)::text = (m.material_code)::text)))
  WHERE (m.is_latest = true);


ALTER VIEW public.materials_latest OWNER TO postgres;

--
-- Name: VIEW materials_latest; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.materials_latest IS 'Convenient view joining material_master with latest version from materials table.';


--
-- Name: product_boms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_boms (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    product_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    status text DEFAULT 'draft'::public.bom_status_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_boms OWNER TO postgres;

--
-- Name: COLUMN product_boms.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_boms.status IS 'Status of the BOM. Valid values are managed in the enums table (enum_type=bom_status)';


--
-- Name: product_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_master (
    style_code character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_master OWNER TO postgres;

--
-- Name: TABLE product_master; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.product_master IS 'Master table for products. Each style_code appears exactly once. Contains item identity and creation metadata.';


--
-- Name: COLUMN product_master.style_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_master.style_code IS 'Unique product identifier. Primary key. Referenced by products table versions.';


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    style_code character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    gender text,
    status text DEFAULT 'development'::public.product_status_enum NOT NULL,
    season_id uuid,
    type_id uuid,
    attributes jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    version character(1) DEFAULT 'A'::bpchar NOT NULL,
    iteration smallint DEFAULT 1 NOT NULL,
    create_by text,
    update_by text,
    is_latest boolean DEFAULT true NOT NULL,
    CONSTRAINT products_iteration_check CHECK (((iteration >= 1) AND (iteration <= 999))),
    CONSTRAINT products_version_check CHECK ((version ~ '^[A-Z]$'::text))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: COLUMN products.gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.gender IS 'Gender category. Valid values are managed in the enums table (enum_type=product_gender)';


--
-- Name: COLUMN products.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.status IS 'Status of the product. Valid values are managed in the enums table (enum_type=product_status)';


--
-- Name: COLUMN products.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.version IS 'Major version letter (A-Z). Currently only A is used.';


--
-- Name: COLUMN products.iteration; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)';


--
-- Name: COLUMN products.is_latest; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.is_latest IS 'Indicates if this is the current/latest version of the product. Only one version per style_code can be latest.';


--
-- Name: products_latest; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.products_latest AS
 SELECT p.id,
    p.style_code,
    p.name,
    p.gender,
    p.status,
    p.season_id,
    p.type_id,
    p.attributes,
    p.created_at,
    p.updated_at,
    p.version,
    p.iteration,
    p.create_by,
    p.update_by,
    p.is_latest,
    pm.created_at AS master_created_at,
    pm.created_by AS master_created_by
   FROM (public.product_master pm
     JOIN public.products p ON (((pm.style_code)::text = (p.style_code)::text)))
  WHERE (p.is_latest = true);


ALTER VIEW public.products_latest OWNER TO postgres;

--
-- Name: VIEW products_latest; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.products_latest IS 'Convenient view joining product_master with latest version from products table.';


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seasons (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    code character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    year integer NOT NULL,
    status text DEFAULT 'planned'::public.season_status_enum NOT NULL,
    type_id uuid,
    attributes jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    create_by text,
    update_by text
);


ALTER TABLE public.seasons OWNER TO postgres;

--
-- Name: COLUMN seasons.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.seasons.status IS 'Status of the season. Valid values are managed in the enums table (enum_type=season_status)';


--
-- Name: supplier_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier_master (
    supplier_code character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.supplier_master OWNER TO postgres;

--
-- Name: TABLE supplier_master; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.supplier_master IS 'Master table for suppliers. Each supplier_code appears exactly once. Contains item identity and creation metadata.';


--
-- Name: COLUMN supplier_master.supplier_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.supplier_master.supplier_code IS 'Unique supplier identifier. Primary key. Referenced by suppliers table versions.';


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    supplier_code character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    region character varying(100),
    status text DEFAULT 'active'::public.supplier_status_enum NOT NULL,
    type_id uuid,
    attributes jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    version character(1) DEFAULT 'A'::bpchar NOT NULL,
    iteration smallint DEFAULT 1 NOT NULL,
    create_by text,
    update_by text,
    is_latest boolean DEFAULT true NOT NULL,
    CONSTRAINT suppliers_iteration_check CHECK (((iteration >= 1) AND (iteration <= 999))),
    CONSTRAINT suppliers_version_check CHECK ((version ~ '^[A-Z]$'::text))
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: COLUMN suppliers.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.suppliers.status IS 'Status of the supplier. Valid values are managed in the enums table (enum_type=supplier_status)';


--
-- Name: COLUMN suppliers.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.suppliers.version IS 'Major version letter (A-Z). Currently only A is used.';


--
-- Name: COLUMN suppliers.iteration; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.suppliers.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)';


--
-- Name: COLUMN suppliers.is_latest; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.suppliers.is_latest IS 'Indicates if this is the current/latest version of the supplier. Only one version per supplier_code can be latest.';


--
-- Name: suppliers_latest; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.suppliers_latest AS
 SELECT s.id,
    s.supplier_code,
    s.name,
    s.region,
    s.status,
    s.type_id,
    s.attributes,
    s.created_at,
    s.updated_at,
    s.version,
    s.iteration,
    s.create_by,
    s.update_by,
    s.is_latest,
    sm.created_at AS master_created_at,
    sm.created_by AS master_created_by
   FROM (public.supplier_master sm
     JOIN public.suppliers s ON (((sm.supplier_code)::text = (s.supplier_code)::text)))
  WHERE (s.is_latest = true);


ALTER VIEW public.suppliers_latest OWNER TO postgres;

--
-- Name: VIEW suppliers_latest; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.suppliers_latest IS 'Convenient view joining supplier_master with latest version from suppliers table.';


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    display_name character varying(255),
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2025_11_08; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_11_08 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_11_08 OWNER TO supabase_admin;

--
-- Name: messages_2025_11_09; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_11_09 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_11_09 OWNER TO supabase_admin;

--
-- Name: messages_2025_11_10; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_11_10 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_11_10 OWNER TO supabase_admin;

--
-- Name: messages_2025_11_11; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_11_11 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_11_11 OWNER TO supabase_admin;

--
-- Name: messages_2025_11_12; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2025_11_12 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_11_12 OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.iceberg_namespaces OWNER TO supabase_storage_admin;

--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.iceberg_tables OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


ALTER TABLE supabase_migrations.seed_files OWNER TO postgres;

--
-- Name: messages_2025_11_08; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_11_08 FOR VALUES FROM ('2025-11-08 00:00:00') TO ('2025-11-09 00:00:00');


--
-- Name: messages_2025_11_09; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_11_09 FOR VALUES FROM ('2025-11-09 00:00:00') TO ('2025-11-10 00:00:00');


--
-- Name: messages_2025_11_10; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_11_10 FOR VALUES FROM ('2025-11-10 00:00:00') TO ('2025-11-11 00:00:00');


--
-- Name: messages_2025_11_11; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_11_11 FOR VALUES FROM ('2025-11-11 00:00:00') TO ('2025-11-12 00:00:00');


--
-- Name: messages_2025_11_12; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_11_12 FOR VALUES FROM ('2025-11-12 00:00:00') TO ('2025-11-13 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
6e2ff9dd-6824-45a5-beeb-4124bda01f15	postgres_cdc_rls	{"region": "us-east-1", "db_host": "oI92PMIm2u4OUx8KqqUaLAhZ/6Vp8rbaluQ2l7/T3no=", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "db_password": "sWBpZNdjggEPTQVlI52Zfw==", "publication": "supabase_realtime", "ssl_enforced": false, "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2025-11-09 06:22:02	2025-11-09 06:22:02
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2025-11-09 06:21:17
20220329161857	2025-11-09 06:21:17
20220410212326	2025-11-09 06:21:17
20220506102948	2025-11-09 06:21:17
20220527210857	2025-11-09 06:21:17
20220815211129	2025-11-09 06:21:17
20220815215024	2025-11-09 06:21:17
20220818141501	2025-11-09 06:21:17
20221018173709	2025-11-09 06:21:17
20221102172703	2025-11-09 06:21:17
20221223010058	2025-11-09 06:21:17
20230110180046	2025-11-09 06:21:18
20230810220907	2025-11-09 06:21:18
20230810220924	2025-11-09 06:21:18
20231024094642	2025-11-09 06:21:18
20240306114423	2025-11-09 06:21:18
20240418082835	2025-11-09 06:21:18
20240625211759	2025-11-09 06:21:18
20240704172020	2025-11-09 06:21:18
20240902173232	2025-11-09 06:21:18
20241106103258	2025-11-09 06:21:18
20250424203323	2025-11-09 06:21:18
20250613072131	2025-11-09 06:21:18
20250711044927	2025-11-09 06:21:18
20250811121559	2025-11-09 06:21:18
20250926223044	2025-11-09 06:21:18
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second, suspend, jwt_jwks, notify_private_alpha, private_only, migrations_ran, broadcast_adapter, max_presence_events_per_second, max_payload_size_in_kb) FROM stdin;
499d0929-b047-4ea8-9b12-49a45d6bdf90	realtime-dev	realtime-dev	iNjicxc4+llvc9wovDvqymwfnj9teWMlyOIbJ8Fh6j2WNU8CIJ2ZgjR6MUIKqSmeDmvpsKLsZ9jgXJmQPpwL8w==	200	2025-11-09 06:22:02	2025-11-09 06:22:02	100	postgres_cdc_rls	100000	100	100	f	{"keys": [{"k": "c3VwZXItc2VjcmV0LWp3dC10b2tlbi13aXRoLWF0LWxlYXN0LTMyLWNoYXJhY3RlcnMtbG9uZw", "kty": "oct"}]}	f	f	64	gen_rpc	1000	3000
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	646bd737-d5a1-4bf4-8c4b-ec5edc74215a	{"action":"user_signedup","actor_id":"3c7728b2-2387-476c-b191-c2a65a49e7d0","actor_username":"admin@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}	2025-11-09 06:24:35.648686+00	
00000000-0000-0000-0000-000000000000	079e8302-5f7d-41f7-b319-181b55f62fac	{"action":"login","actor_id":"3c7728b2-2387-476c-b191-c2a65a49e7d0","actor_username":"admin@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-11-09 06:24:35.744618+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
3c7728b2-2387-476c-b191-c2a65a49e7d0	3c7728b2-2387-476c-b191-c2a65a49e7d0	{"sub": "3c7728b2-2387-476c-b191-c2a65a49e7d0", "email": "admin@gmail.com", "email_verified": false, "phone_verified": false}	email	2025-11-09 06:24:35.645584+00	2025-11-09 06:24:35.645615+00	2025-11-09 06:24:35.645615+00	9b8ca243-2248-4099-84de-48e1db7ec41e
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
2b00a00e-c1f5-4530-a595-069b49e166d6	2025-11-09 06:24:35.749665+00	2025-11-09 06:24:35.749665+00	password	4978f900-eee1-4b36-b376-b4cd73462c89
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	1	54j3tcn2mesi	3c7728b2-2387-476c-b191-c2a65a49e7d0	f	2025-11-09 06:24:35.747228+00	2025-11-09 06:24:35.747228+00	\N	2b00a00e-c1f5-4530-a595-069b49e166d6
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id) FROM stdin;
2b00a00e-c1f5-4530-a595-069b49e166d6	3c7728b2-2387-476c-b191-c2a65a49e7d0	2025-11-09 06:24:35.745629+00	2025-11-09 06:24:35.745629+00	\N	aal1	\N	\N	node	172.18.0.1	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	3c7728b2-2387-476c-b191-c2a65a49e7d0	authenticated	authenticated	admin@gmail.com	$2a$10$vgWkiqPVavVGH4Rtu3UEsOY8gSB9GzYq8tjFSFoMbjcyZNFCgDarW	2025-11-09 06:24:35.649632+00	\N		\N		\N			\N	2025-11-09 06:24:35.745524+00	{"provider": "email", "providers": ["email"]}	{"sub": "3c7728b2-2387-476c-b191-c2a65a49e7d0", "email": "admin@gmail.com", "email_verified": true, "phone_verified": false}	\N	2025-11-09 06:24:35.63946+00	2025-11-09 06:24:35.749049+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: attribute_definitions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attribute_definitions (id, entity_type, key, label, data_type, required, order_index, options, is_active, created_at, updated_at) FROM stdin;
4c6f2d2e-732c-4924-a1ac-24c29283ab54	season	description	Description	string	f	1	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
96f7582d-759b-41cf-928e-8267e098e21c	season	start_date	Start Date	date	f	2	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
bf113420-09c5-4f6b-a2e6-dc6a3dcf98ed	season	end_date	End Date	date	f	3	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
ce32f191-30ba-44bf-9184-455a453c1a1a	product	brand	Brand	string	f	1	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
3fdaf409-1064-459c-bbcf-3fda22247764	product	description	Description	string	f	2	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
c2ef962f-fc4d-4580-8e32-c8556ea69d05	product	target_price	Target Price ($)	number	f	3	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
6e79a6be-31b6-42e1-8cba-75605610c286	product	size_range	Size Range	enum	f	4	{"values": ["XS-XL", "S-XXL", "One Size"]}	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
80461216-27e9-43af-a951-a1f794d64583	material	composition	Composition	string	f	1	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
0951dd17-de6c-402a-8ceb-33776761ec72	material	weight	Weight (g/m²)	number	f	2	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
1046c7be-cc80-46a7-99cd-1973c896bb7a	material	width	Width (cm)	number	f	3	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
3a75f871-3eda-4310-8116-69edd69f23c1	material	care_instructions	Care Instructions	string	f	4	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
cbdb341e-73a5-4f9d-af53-eca752593379	supplier	contact_person	Contact Person	string	f	1	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
8ae2c94a-d200-4aa8-9488-ed2496a24619	supplier	email	Email	string	f	2	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
dbba2edc-912e-402d-afa2-ff1885042010	supplier	phone	Phone	string	f	3	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
bcd2aa1d-909f-4cb1-80a6-b2ac693af5e0	supplier	address	Address	string	f	4	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
3b59e96b-e0f6-455b-aa8b-4674fc710376	supplier	payment_terms	Payment Terms	string	f	5	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
1379ab4e-f93d-4b05-8274-131233fceab3	color	pantone_code	Pantone Code	string	f	1	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
4881e214-680c-45c6-93fe-ad6ae967e6e9	color	cmyk	CMYK	string	f	2	\N	t	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
\.


--
-- Data for Name: bom_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bom_items (id, bom_id, line_number, material_id, color_id, supplier_id, quantity, unit, attributes, created_at, updated_at) FROM stdin;
d1db2d03-0ee5-4fa1-9daf-1ed7a5314e09	9d230601-9b9b-4c4f-83af-83d5a4a353a6	10	be305f5f-c0b1-4611-b57b-f2e2ab74f215	ec2e75e7-0955-4f64-bb15-5ff5160c3c04	fca31b4f-8f8f-43c0-90df-71f2457805ba	1.2000	yards	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
214cd9b3-0ee1-4301-91b3-4483f6fe90d3	9d230601-9b9b-4c4f-83af-83d5a4a353a6	20	343c2bde-76d8-450a-a9ec-26f60d8e7499	\N	21f31a35-ec2e-431b-b9fc-8e78e84dfbd0	4.0000	pieces	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
64cf3a46-ffe3-42e4-8c10-36714939c6e5	50ac4df0-5b30-4e61-a4cd-96257102372f	10	6c7919a9-e21b-495d-b68e-1d99bfa4b69f	bbc4b2f8-c166-475e-9f0d-534a932a5343	fca31b4f-8f8f-43c0-90df-71f2457805ba	0.9000	yards	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
59725609-e1d1-4a42-b3fd-7929b645b4ad	77735123-f606-4d3e-b479-373fe47f18e4	1	be305f5f-c0b1-4611-b57b-f2e2ab74f215	\N	\N	1.0000	pcs	{}	2025-11-09 06:28:27.331877+00	2025-11-09 06:28:27.331877+00
9aa3b1ec-01f2-4e5f-a8a5-029d04a4b01b	77735123-f606-4d3e-b479-373fe47f18e4	2	be305f5f-c0b1-4611-b57b-f2e2ab74f215	\N	\N	1.0000	pcs	{}	2025-11-09 06:28:28.738471+00	2025-11-09 06:28:28.738471+00
0bc3f901-d7ad-4e0c-b1e4-375ccce445b3	e016487a-59e2-45a4-982f-0054fadd948d	1	be305f5f-c0b1-4611-b57b-f2e2ab74f215	\N	\N	1.0000	pcs	{}	2025-11-09 06:34:01.143539+00	2025-11-09 06:34:01.143539+00
d1a4ca30-e9c4-4398-9cdc-8af8b53a3935	e016487a-59e2-45a4-982f-0054fadd948d	2	6c7919a9-e21b-495d-b68e-1d99bfa4b69f	\N	\N	1.0000	pcs	{}	2025-11-09 06:34:03.082954+00	2025-11-09 06:34:03.082954+00
\.


--
-- Data for Name: colors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.colors (id, color_code, name, rgb_hex, status, type_id, attributes, created_at, updated_at, create_by, update_by) FROM stdin;
bbc4b2f8-c166-475e-9f0d-534a932a5343	BLK	Black	#000000	active	55555555-5555-5555-5555-555555555552	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	\N	\N
ec2e75e7-0955-4f64-bb15-5ff5160c3c04	WHT	White	#FFFFFF	active	55555555-5555-5555-5555-555555555552	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	\N	\N
968d206b-8b9e-4f7f-bef1-12624b8cb6bf	NVY	Navy	#001F3F	active	55555555-5555-5555-5555-555555555552	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	\N	\N
f2692102-10ef-42a6-8910-d641ecc57e34	GRY	Grey	#808080	active	55555555-5555-5555-5555-555555555552	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	\N	\N
e45e4e49-7698-466e-8e06-eee2e2a79e45	RED	Red	#FF4136	active	55555555-5555-5555-5555-555555555552	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	\N	\N
\.


--
-- Data for Name: entity_type_nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_type_nodes (id, entity_type, parent_id, name, code, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	season	\N	Season Types	SEASON_ROOT	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
11111111-1111-1111-1111-111111111112	season	11111111-1111-1111-1111-111111111111	Spring/Summer	SS	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
11111111-1111-1111-1111-111111111113	season	11111111-1111-1111-1111-111111111111	Fall/Winter	FW	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
11111111-1111-1111-1111-111111111114	season	11111111-1111-1111-1111-111111111111	Holiday	HOLIDAY	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222221	product	\N	Product Types	PRODUCT_ROOT	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222222	product	22222222-2222-2222-2222-222222222221	Apparel	APPAREL	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222223	product	22222222-2222-2222-2222-222222222222	Mens	MENS	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222224	product	22222222-2222-2222-2222-222222222222	Womens	WOMENS	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222225	product	22222222-2222-2222-2222-222222222223	Tops	MENS_TOPS	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222226	product	22222222-2222-2222-2222-222222222223	Bottoms	MENS_BOTTOMS	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222227	product	22222222-2222-2222-2222-222222222224	Tops	WOMENS_TOPS	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222228	product	22222222-2222-2222-2222-222222222224	Bottoms	WOMENS_BOTTOMS	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
22222222-2222-2222-2222-222222222229	product	22222222-2222-2222-2222-222222222221	Accessories	ACCESSORIES	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333331	material	\N	Material Types	MATERIAL_ROOT	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333332	material	33333333-3333-3333-3333-333333333331	Fabric	FABRIC	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333333	material	33333333-3333-3333-3333-333333333332	Cotton	COTTON	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333334	material	33333333-3333-3333-3333-333333333332	Polyester	POLYESTER	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333335	material	33333333-3333-3333-3333-333333333332	Wool	WOOL	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333336	material	33333333-3333-3333-3333-333333333331	Trim	TRIM	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333337	material	33333333-3333-3333-3333-333333333336	Zipper	ZIPPER	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
33333333-3333-3333-3333-333333333338	material	33333333-3333-3333-3333-333333333336	Button	BUTTON	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
44444444-4444-4444-4444-444444444441	supplier	\N	Supplier Types	SUPPLIER_ROOT	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
44444444-4444-4444-4444-444444444442	supplier	44444444-4444-4444-4444-444444444441	Fabric Mill	FABRIC_MILL	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
44444444-4444-4444-4444-444444444443	supplier	44444444-4444-4444-4444-444444444441	Trim Supplier	TRIM_SUPPLIER	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
44444444-4444-4444-4444-444444444444	supplier	44444444-4444-4444-4444-444444444441	Factory	FACTORY	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
55555555-5555-5555-5555-555555555551	color	\N	Color Types	COLOR_ROOT	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
55555555-5555-5555-5555-555555555552	color	55555555-5555-5555-5555-555555555551	Basic Colors	BASIC	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
55555555-5555-5555-5555-555555555553	color	55555555-5555-5555-5555-555555555551	Seasonal Colors	SEASONAL	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
\.


--
-- Data for Name: enums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enums (id, enum_type, enum_value, label, order_index, is_active, created_at, updated_at) FROM stdin;
00c29e33-a107-4b83-9575-3cb62baeaa34	season_status	planned	Planned	1	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
de8c3c9e-b608-4e03-95c1-e04b334facbe	season_status	active	Active	2	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
d20c291c-242b-4821-bfb9-1712a1370be6	season_status	archived	Archived	3	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
62bff649-8718-42b3-90b7-420061173603	product_status	development	Development	1	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
434e2363-aed4-4b79-bd74-4cc04f7394f4	product_status	pre-production	Pre-Production	2	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
4f43783a-9110-4eea-b25d-f77811011b4d	product_status	production	Production	3	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
0fe21a2e-d0f7-41db-af2b-8b74b1127167	product_status	inactive	Inactive	4	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
9f4b47db-a9c1-4e71-9f64-dc2db1305ab9	product_gender	unisex	Unisex	1	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
7ab441a4-6c22-4c58-b270-aeba8c3937bc	product_gender	women	Women	2	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
50d0267a-bf95-4500-9d9f-359e34e8e349	product_gender	men	Men	3	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
fca7a68b-8bd1-4156-b39a-492baad834b6	product_gender	kids	Kids	4	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
ed02df31-30bd-4d74-b59a-f5a0af341871	material_status	in_development	In Development	1	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
7c5e88a2-69e2-47d1-9ed5-ab7170f3a7f6	material_status	active	Active	2	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
2d9862d8-7643-4938-9128-392cb059ba30	material_status	dropped	Dropped	3	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
cf9546a0-dbd9-4935-ad94-f951873dd066	material_status	rfq	RFQ	4	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
1d05da62-faae-4472-bb7b-24dcc92f72a6	supplier_status	active	Active	1	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
c7763ff6-ddd4-43aa-9c0b-88ca43ef9945	supplier_status	inactive	Inactive	2	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
89c4f438-532f-4aaf-a909-2e7c4ad7d195	color_status	active	Active	1	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
efe7ba93-38e5-44b8-aa08-320d3bfc5512	color_status	inactive	Inactive	2	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
64de8ef9-973f-4334-8fc6-0a7516f36d93	bom_status	draft	Draft	1	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
3223a2f9-4483-4a41-b41a-d943fd2c0518	bom_status	active	Active	2	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
f6889a64-db0c-41ee-84e5-7bbe8415e26a	bom_status	archived	Archived	3	t	2025-11-09 06:21:53.307122+00	2025-11-09 06:21:53.307122+00
\.


--
-- Data for Name: material_colors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material_colors (id, material_id, color_id, created_at, updated_at) FROM stdin;
ad56c981-9eca-41d6-9aca-e8c7a40416bb	be305f5f-c0b1-4611-b57b-f2e2ab74f215	bbc4b2f8-c166-475e-9f0d-534a932a5343	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
962307c6-b3a3-4202-b61b-2d957e4cc06c	be305f5f-c0b1-4611-b57b-f2e2ab74f215	ec2e75e7-0955-4f64-bb15-5ff5160c3c04	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
2d045a32-30f0-437c-b8d1-39b44c9c623f	be305f5f-c0b1-4611-b57b-f2e2ab74f215	968d206b-8b9e-4f7f-bef1-12624b8cb6bf	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
f652fa63-f12b-4cb0-b79c-5a418914574d	6c7919a9-e21b-495d-b68e-1d99bfa4b69f	bbc4b2f8-c166-475e-9f0d-534a932a5343	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
6dc4bf7b-d473-4fbd-a792-e743cbdfc4d7	6c7919a9-e21b-495d-b68e-1d99bfa4b69f	e45e4e49-7698-466e-8e06-eee2e2a79e45	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
\.


--
-- Data for Name: material_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material_master (material_code, created_at, created_by, updated_at) FROM stdin;
COT-001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
POL-001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
ZIP-001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
BTN-001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
\.


--
-- Data for Name: material_suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material_suppliers (id, material_id, supplier_id, price, currency, attributes, created_at, updated_at) FROM stdin;
19fe1184-75a4-472e-97f2-539b1013d571	be305f5f-c0b1-4611-b57b-f2e2ab74f215	fca31b4f-8f8f-43c0-90df-71f2457805ba	8.50	USD	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
bf795e2e-4766-4d77-bd53-1efe5eb5cf64	6c7919a9-e21b-495d-b68e-1d99bfa4b69f	fca31b4f-8f8f-43c0-90df-71f2457805ba	6.75	USD	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
773cb0d1-0ef4-4b20-a30b-de049162acb3	f340b488-0b2b-44f7-b3cb-f54bc97fdf20	21f31a35-ec2e-431b-b9fc-8e78e84dfbd0	1.20	USD	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
69866cd2-a222-4c2a-9830-fd0eb2be9886	343c2bde-76d8-450a-a9ec-26f60d8e7499	21f31a35-ec2e-431b-b9fc-8e78e84dfbd0	0.15	USD	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials (id, material_code, name, status, type_id, attributes, created_at, updated_at, version, iteration, create_by, update_by, is_latest) FROM stdin;
be305f5f-c0b1-4611-b57b-f2e2ab74f215	COT-001	100% Cotton Jersey	active	33333333-3333-3333-3333-333333333333	{"width": 150, "weight": 180, "composition": "100% Cotton"}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
6c7919a9-e21b-495d-b68e-1d99bfa4b69f	POL-001	Polyester Performance	active	33333333-3333-3333-3333-333333333334	{"width": 160, "weight": 150, "composition": "100% Polyester"}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
f340b488-0b2b-44f7-b3cb-f54bc97fdf20	ZIP-001	YKK Metal Zipper 5"	active	33333333-3333-3333-3333-333333333337	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
343c2bde-76d8-450a-a9ec-26f60d8e7499	BTN-001	Plastic Button 15mm	active	33333333-3333-3333-3333-333333333338	{}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
\.


--
-- Data for Name: product_boms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_boms (id, product_id, name, status, created_at, updated_at) FROM stdin;
9d230601-9b9b-4c4f-83af-83d5a4a353a6	3bf7cbde-8f1d-4eb9-87ed-8fff2c67c70a	Default BOM	draft	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
50ac4df0-5b30-4e61-a4cd-96257102372f	fd4956ce-7baa-47e3-9527-367a9a457329	Default BOM	draft	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00
77735123-f606-4d3e-b479-373fe47f18e4	b7872d7d-0d7c-4712-a985-8dc3d6b9cf42	Default BOM	draft	2025-11-09 06:28:23.908915+00	2025-11-09 06:28:23.908915+00
e016487a-59e2-45a4-982f-0054fadd948d	d2ceba14-a853-4302-8504-9da6bad0dc05	Default BOM	draft	2025-11-09 06:33:59.809036+00	2025-11-09 06:33:59.809036+00
\.


--
-- Data for Name: product_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_master (style_code, created_at, created_by, updated_at) FROM stdin;
MT-SS25-001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
WT-SS25-001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
001 - Test Woamn Top	2025-11-09 06:27:30.75643+00	admin@gmail.com	2025-11-09 06:27:30.75643+00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, style_code, name, gender, status, season_id, type_id, attributes, created_at, updated_at, version, iteration, create_by, update_by, is_latest) FROM stdin;
3bf7cbde-8f1d-4eb9-87ed-8fff2c67c70a	MT-SS25-001	Basic Cotton T-Shirt	Mens	development	f904377a-52da-404e-8565-b28b2bec417b	22222222-2222-2222-2222-222222222225	{"brand": "FlexLite", "size_range": "S-XXL", "description": "Classic crew neck t-shirt", "target_price": 29.99}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
fd4956ce-7baa-47e3-9527-367a9a457329	WT-SS25-001	Performance Tank Top	Womens	development	f904377a-52da-404e-8565-b28b2bec417b	22222222-2222-2222-2222-222222222227	{"brand": "FlexLite", "size_range": "XS-XL", "description": "Athletic tank with moisture wicking", "target_price": 34.99}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
b7872d7d-0d7c-4712-a985-8dc3d6b9cf42	001 - Test Woamn Top	Test Woamn Top	women	development	f904377a-52da-404e-8565-b28b2bec417b	22222222-2222-2222-2222-222222222227	{"brand": "MyBrand", "size_range": "XS-XL", "description": "My 1 test", "target_price": 25.88}	2025-11-09 06:27:30.79989+00	2025-11-09 06:28:48.456544+00	A	1	admin@gmail.com	admin@gmail.com	f
d2ceba14-a853-4302-8504-9da6bad0dc05	001 - Test Woamn Top	Test Woamn Top	women	development	f904377a-52da-404e-8565-b28b2bec417b	22222222-2222-2222-2222-222222222227	{"brand": "MyBrand", "size_range": "XS-XL", "description": "My 1 test 1", "target_price": 25.88}	2025-11-09 06:28:48.501111+00	2025-11-09 06:28:48.442+00	A	2	admin@gmail.com	admin@gmail.com	t
\.


--
-- Data for Name: seasons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seasons (id, code, name, year, status, type_id, attributes, created_at, updated_at, create_by, update_by) FROM stdin;
f904377a-52da-404e-8565-b28b2bec417b	SS25	Spring/Summer 2025	2025	active	11111111-1111-1111-1111-111111111112	{"end_date": "2025-06-30", "start_date": "2025-01-01", "description": "Spring Summer 2025 Collection"}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	\N	\N
62e4e708-5179-48c3-ac68-3d5de54bf540	FW25	Fall/Winter 2025	2025	planned	11111111-1111-1111-1111-111111111113	{"end_date": "2025-12-31", "start_date": "2025-07-01", "description": "Fall Winter 2025 Collection"}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	\N	\N
\.


--
-- Data for Name: supplier_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier_master (supplier_code, created_at, created_by, updated_at) FROM stdin;
FAB001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
TRIM001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
FACT001	2025-11-09 06:21:53.891625+00	system	2025-11-09 06:21:53.891625+00
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id, supplier_code, name, region, status, type_id, attributes, created_at, updated_at, version, iteration, create_by, update_by, is_latest) FROM stdin;
fca31b4f-8f8f-43c0-90df-71f2457805ba	FAB001	Premium Fabrics Co.	Asia	active	44444444-4444-4444-4444-444444444442	{"email": "john@premiumfabrics.com", "contact_person": "John Doe"}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
21f31a35-ec2e-431b-b9fc-8e78e84dfbd0	TRIM001	Global Trim Supply	Europe	active	44444444-4444-4444-4444-444444444443	{"email": "jane@globaltrim.com", "contact_person": "Jane Smith"}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
df4bc23e-2435-461a-9535-c7007f390aaf	FACT001	Quality Manufacturing Ltd.	Asia	active	44444444-4444-4444-4444-444444444444	{"email": "mike@qualitymfg.com", "contact_person": "Mike Chen"}	2025-11-09 06:21:53.891625+00	2025-11-09 06:21:53.891625+00	A	1	system	system	t
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, display_name, is_admin, created_at, updated_at) FROM stdin;
3c7728b2-2387-476c-b191-c2a65a49e7d0	admin@gmail.com	admin@gmail.com	t	2025-11-09 06:24:35.638964+00	2025-11-09 06:32:06.696727+00
\.


--
-- Data for Name: messages_2025_11_08; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_11_08 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_11_09; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_11_09 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_11_10; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_11_10 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_11_11; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_11_11 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: messages_2025_11_12; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.messages_2025_11_12 (topic, extension, payload, event, private, updated_at, inserted_at, id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-11-09 06:21:21
20211116045059	2025-11-09 06:21:21
20211116050929	2025-11-09 06:21:21
20211116051442	2025-11-09 06:21:21
20211116212300	2025-11-09 06:21:21
20211116213355	2025-11-09 06:21:21
20211116213934	2025-11-09 06:21:21
20211116214523	2025-11-09 06:21:21
20211122062447	2025-11-09 06:21:21
20211124070109	2025-11-09 06:21:21
20211202204204	2025-11-09 06:21:22
20211202204605	2025-11-09 06:21:22
20211210212804	2025-11-09 06:21:22
20211228014915	2025-11-09 06:21:22
20220107221237	2025-11-09 06:21:22
20220228202821	2025-11-09 06:21:22
20220312004840	2025-11-09 06:21:22
20220603231003	2025-11-09 06:21:22
20220603232444	2025-11-09 06:21:22
20220615214548	2025-11-09 06:21:22
20220712093339	2025-11-09 06:21:23
20220908172859	2025-11-09 06:21:23
20220916233421	2025-11-09 06:21:23
20230119133233	2025-11-09 06:21:23
20230128025114	2025-11-09 06:21:23
20230128025212	2025-11-09 06:21:23
20230227211149	2025-11-09 06:21:23
20230228184745	2025-11-09 06:21:23
20230308225145	2025-11-09 06:21:23
20230328144023	2025-11-09 06:21:23
20231018144023	2025-11-09 06:21:23
20231204144023	2025-11-09 06:21:23
20231204144024	2025-11-09 06:21:24
20231204144025	2025-11-09 06:21:24
20240108234812	2025-11-09 06:21:24
20240109165339	2025-11-09 06:21:24
20240227174441	2025-11-09 06:21:24
20240311171622	2025-11-09 06:21:24
20240321100241	2025-11-09 06:21:24
20240401105812	2025-11-09 06:21:24
20240418121054	2025-11-09 06:21:24
20240523004032	2025-11-09 06:21:24
20240618124746	2025-11-09 06:21:25
20240801235015	2025-11-09 06:21:25
20240805133720	2025-11-09 06:21:25
20240827160934	2025-11-09 06:21:25
20240919163303	2025-11-09 06:21:25
20240919163305	2025-11-09 06:21:25
20241019105805	2025-11-09 06:21:25
20241030150047	2025-11-09 06:21:25
20241108114728	2025-11-09 06:21:25
20241121104152	2025-11-09 06:21:25
20241130184212	2025-11-09 06:21:25
20241220035512	2025-11-09 06:21:25
20241220123912	2025-11-09 06:21:25
20241224161212	2025-11-09 06:21:25
20250107150512	2025-11-09 06:21:26
20250110162412	2025-11-09 06:21:26
20250123174212	2025-11-09 06:21:26
20250128220012	2025-11-09 06:21:26
20250506224012	2025-11-09 06:21:26
20250523164012	2025-11-09 06:21:26
20250714121412	2025-11-09 06:21:26
20250905041441	2025-11-09 06:21:26
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (id, type, format, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_namespaces; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_namespaces (id, bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: iceberg_tables; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.iceberg_tables (id, namespace_id, bucket_id, name, location, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-11-09 06:21:39.182931
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-11-09 06:21:39.215828
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-11-09 06:21:39.244293
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-11-09 06:21:39.282704
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-11-09 06:21:39.341997
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-11-09 06:21:39.377858
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-11-09 06:21:39.408252
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-11-09 06:21:39.43625
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-11-09 06:21:39.459987
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-11-09 06:21:39.486787
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-11-09 06:21:39.509432
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-11-09 06:21:39.536379
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-11-09 06:21:39.559744
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-11-09 06:21:39.586487
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-11-09 06:21:39.609521
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-11-09 06:21:39.645216
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-11-09 06:21:39.676457
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-11-09 06:21:39.702821
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-11-09 06:21:39.726498
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-11-09 06:21:39.752939
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-11-09 06:21:39.776779
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-11-09 06:21:39.803016
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-11-09 06:21:39.893978
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-11-09 06:21:39.994867
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-11-09 06:21:40.02508
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-11-09 06:21:40.052781
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2025-11-09 06:21:40.077973
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2025-11-09 06:21:40.111301
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2025-11-09 06:21:40.228109
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2025-11-09 06:21:40.254943
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2025-11-09 06:21:40.279591
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2025-11-09 06:21:40.411288
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2025-11-09 06:21:40.511445
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2025-11-09 06:21:40.611177
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2025-11-09 06:21:40.636438
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2025-11-09 06:21:40.661328
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2025-11-09 06:21:40.686559
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-11-09 06:21:40.711284
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2025-11-09 06:21:40.736868
39	add-search-v2-sort-support	39cf7d1e6bf515f4b02e41237aba845a7b492853	2025-11-09 06:21:40.769932
40	fix-prefix-race-conditions-optimized	fd02297e1c67df25a9fc110bf8c8a9af7fb06d1f	2025-11-09 06:21:40.795891
41	add-object-level-update-trigger	44c22478bf01744b2129efc480cd2edc9a7d60e9	2025-11-09 06:21:40.828277
42	rollback-prefix-triggers	f2ab4f526ab7f979541082992593938c05ee4b47	2025-11-09 06:21:40.854121
43	fix-object-level	ab837ad8f1c7d00cc0b7310e989a23388ff29fc6	2025-11-09 06:21:40.8782
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2025-11-09 06:21:11.553162+00
20210809183423_update_grants	2025-11-09 06:21:11.553162+00
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
20250108000000	{"-- FlexLite PLM Initial Schema Migration\n-- 完整的数据库表结构定义\n\n-- =====================================================\n-- 1. 启用必要的扩展\n-- =====================================================\nCREATE EXTENSION IF NOT EXISTS \\"uuid-ossp\\"","-- =====================================================\n-- 2. 自定义枚举类型\n-- =====================================================\n\n-- 实体类型枚举\nCREATE TYPE entity_type_enum AS ENUM (\n  'season',\n  'product',\n  'material',\n  'supplier',\n  'color'\n)","-- 属性数据类型枚举\nCREATE TYPE attribute_data_type_enum AS ENUM (\n  'string',\n  'number',\n  'boolean',\n  'date',\n  'enum'\n)","-- Season 状态枚举\nCREATE TYPE season_status_enum AS ENUM (\n  'planned',\n  'active',\n  'archived'\n)","-- Product 状态枚举\nCREATE TYPE product_status_enum AS ENUM (\n  'development',\n  'pre-production',\n  'production',\n  'inactive'\n)","-- Material 状态枚举\nCREATE TYPE material_status_enum AS ENUM (\n  'in_development',\n  'active',\n  'dropped',\n  'rfq'\n)","-- Supplier 状态枚举\nCREATE TYPE supplier_status_enum AS ENUM (\n  'active',\n  'inactive'\n)","-- Color 状态枚举\nCREATE TYPE color_status_enum AS ENUM (\n  'active',\n  'inactive'\n)","-- BOM 状态枚举\nCREATE TYPE bom_status_enum AS ENUM (\n  'draft',\n  'active',\n  'archived'\n)","-- =====================================================\n-- 3. Type Manager 相关表\n-- =====================================================\n\n-- 实体类型节点表（树形结构）\nCREATE TABLE entity_type_nodes (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  entity_type entity_type_enum NOT NULL,\n  parent_id UUID REFERENCES entity_type_nodes(id) ON DELETE CASCADE,\n  name VARCHAR(255) NOT NULL,\n  code VARCHAR(100),\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_entity_type_nodes_entity_type ON entity_type_nodes(entity_type)","CREATE INDEX idx_entity_type_nodes_parent_id ON entity_type_nodes(parent_id)","-- 属性定义表\nCREATE TABLE attribute_definitions (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  entity_type entity_type_enum NOT NULL,\n  key VARCHAR(100) NOT NULL,\n  label VARCHAR(255) NOT NULL,\n  data_type attribute_data_type_enum NOT NULL,\n  required BOOLEAN NOT NULL DEFAULT FALSE,\n  order_index INTEGER NOT NULL DEFAULT 0,\n  options JSONB,\n  is_active BOOLEAN NOT NULL DEFAULT TRUE,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  UNIQUE(entity_type, key)\n)","-- 索引\nCREATE INDEX idx_attribute_definitions_entity_type ON attribute_definitions(entity_type)","CREATE INDEX idx_attribute_definitions_is_active ON attribute_definitions(is_active)","-- =====================================================\n-- 4. 用户表\n-- =====================================================\n\n-- 用户表（关联 Supabase Auth）\nCREATE TABLE users (\n  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,\n  email VARCHAR(255) NOT NULL UNIQUE,\n  display_name VARCHAR(255),\n  is_admin BOOLEAN NOT NULL DEFAULT FALSE,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_users_email ON users(email)","CREATE INDEX idx_users_is_admin ON users(is_admin)","-- =====================================================\n-- 5. 核心实体表\n-- =====================================================\n\n-- 5.1 Seasons（季度/季节表）\nCREATE TABLE seasons (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  code VARCHAR(100) NOT NULL UNIQUE,\n  name VARCHAR(255) NOT NULL,\n  year INTEGER NOT NULL,\n  status season_status_enum NOT NULL DEFAULT 'planned',\n  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,\n  attributes JSONB DEFAULT '{}',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_seasons_code ON seasons(code)","CREATE INDEX idx_seasons_status ON seasons(status)","CREATE INDEX idx_seasons_type_id ON seasons(type_id)","CREATE INDEX idx_seasons_year ON seasons(year)","-- 5.2 Products（产品表）\nCREATE TABLE products (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  style_code VARCHAR(100) NOT NULL UNIQUE,\n  name VARCHAR(255) NOT NULL,\n  gender VARCHAR(50),\n  status product_status_enum NOT NULL DEFAULT 'development',\n  season_id UUID REFERENCES seasons(id) ON DELETE SET NULL,\n  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,\n  attributes JSONB DEFAULT '{}',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_products_style_code ON products(style_code)","CREATE INDEX idx_products_status ON products(status)","CREATE INDEX idx_products_season_id ON products(season_id)","CREATE INDEX idx_products_type_id ON products(type_id)","-- 5.3 Materials（物料表）\nCREATE TABLE materials (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  material_code VARCHAR(100) NOT NULL UNIQUE,\n  name VARCHAR(255) NOT NULL,\n  status material_status_enum NOT NULL DEFAULT 'in_development',\n  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,\n  attributes JSONB DEFAULT '{}',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_materials_material_code ON materials(material_code)","CREATE INDEX idx_materials_status ON materials(status)","CREATE INDEX idx_materials_type_id ON materials(type_id)","-- 5.4 Suppliers（供应商表）\nCREATE TABLE suppliers (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  supplier_code VARCHAR(100) NOT NULL UNIQUE,\n  name VARCHAR(255) NOT NULL,\n  region VARCHAR(100),\n  status supplier_status_enum NOT NULL DEFAULT 'active',\n  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,\n  attributes JSONB DEFAULT '{}',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_suppliers_supplier_code ON suppliers(supplier_code)","CREATE INDEX idx_suppliers_status ON suppliers(status)","CREATE INDEX idx_suppliers_type_id ON suppliers(type_id)","-- 5.5 Colors（颜色表）\nCREATE TABLE colors (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  color_code VARCHAR(100) NOT NULL UNIQUE,\n  name VARCHAR(255) NOT NULL,\n  rgb_hex VARCHAR(7),\n  status color_status_enum NOT NULL DEFAULT 'active',\n  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,\n  attributes JSONB DEFAULT '{}',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_colors_color_code ON colors(color_code)","CREATE INDEX idx_colors_status ON colors(status)","CREATE INDEX idx_colors_type_id ON colors(type_id)","-- =====================================================\n-- 6. 关系表\n-- =====================================================\n\n-- 6.1 Material-Supplier 关联表（物料-供应商-价格）\nCREATE TABLE material_suppliers (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  material_id UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,\n  supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,\n  price NUMERIC(12, 2),\n  currency VARCHAR(10) DEFAULT 'USD',\n  attributes JSONB DEFAULT '{}',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  UNIQUE(material_id, supplier_id)\n)","-- 索引\nCREATE INDEX idx_material_suppliers_material_id ON material_suppliers(material_id)","CREATE INDEX idx_material_suppliers_supplier_id ON material_suppliers(supplier_id)","-- 6.2 Material-Color 关联表（物料-颜色）\nCREATE TABLE material_colors (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  material_id UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,\n  color_id UUID NOT NULL REFERENCES colors(id) ON DELETE CASCADE,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  UNIQUE(material_id, color_id)\n)","-- 索引\nCREATE INDEX idx_material_colors_material_id ON material_colors(material_id)","CREATE INDEX idx_material_colors_color_id ON material_colors(color_id)","-- 6.3 Product BOM 表（产品物料清单）\nCREATE TABLE product_boms (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,\n  name VARCHAR(255) NOT NULL,\n  status bom_status_enum NOT NULL DEFAULT 'draft',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- 索引\nCREATE INDEX idx_product_boms_product_id ON product_boms(product_id)","CREATE INDEX idx_product_boms_status ON product_boms(status)","-- 6.4 BOM Items 表（BOM行项目 - 单层BOM）\nCREATE TABLE bom_items (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  bom_id UUID NOT NULL REFERENCES product_boms(id) ON DELETE CASCADE,\n  line_number INTEGER NOT NULL,\n  material_id UUID NOT NULL REFERENCES materials(id) ON DELETE RESTRICT,\n  color_id UUID REFERENCES colors(id) ON DELETE SET NULL,\n  supplier_id UUID REFERENCES suppliers(id) ON DELETE SET NULL,\n  quantity NUMERIC(12, 4) NOT NULL,\n  unit VARCHAR(50) NOT NULL,\n  attributes JSONB DEFAULT '{}',\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  UNIQUE(bom_id, line_number)\n)","-- 索引\nCREATE INDEX idx_bom_items_bom_id ON bom_items(bom_id)","CREATE INDEX idx_bom_items_material_id ON bom_items(material_id)","CREATE INDEX idx_bom_items_color_id ON bom_items(color_id)","CREATE INDEX idx_bom_items_supplier_id ON bom_items(supplier_id)","-- =====================================================\n-- 7. 触发器：自动更新 updated_at 字段\n-- =====================================================\n\n-- 创建通用的更新时间戳函数\nCREATE OR REPLACE FUNCTION update_updated_at_column()\nRETURNS TRIGGER AS $$\nBEGIN\n  NEW.updated_at = NOW();\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql","-- 为所有需要的表创建触发器\nCREATE TRIGGER update_entity_type_nodes_updated_at BEFORE UPDATE ON entity_type_nodes\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_attribute_definitions_updated_at BEFORE UPDATE ON attribute_definitions\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_seasons_updated_at BEFORE UPDATE ON seasons\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_materials_updated_at BEFORE UPDATE ON materials\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON suppliers\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_colors_updated_at BEFORE UPDATE ON colors\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_material_suppliers_updated_at BEFORE UPDATE ON material_suppliers\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_material_colors_updated_at BEFORE UPDATE ON material_colors\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_product_boms_updated_at BEFORE UPDATE ON product_boms\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","CREATE TRIGGER update_bom_items_updated_at BEFORE UPDATE ON bom_items\n  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()","-- =====================================================\n-- 8. Row Level Security (RLS) 策略\n-- =====================================================\n\n-- 启用所有表的 RLS\nALTER TABLE entity_type_nodes ENABLE ROW LEVEL SECURITY","ALTER TABLE attribute_definitions ENABLE ROW LEVEL SECURITY","ALTER TABLE users ENABLE ROW LEVEL SECURITY","ALTER TABLE seasons ENABLE ROW LEVEL SECURITY","ALTER TABLE products ENABLE ROW LEVEL SECURITY","ALTER TABLE materials ENABLE ROW LEVEL SECURITY","ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY","ALTER TABLE colors ENABLE ROW LEVEL SECURITY","ALTER TABLE material_suppliers ENABLE ROW LEVEL SECURITY","ALTER TABLE material_colors ENABLE ROW LEVEL SECURITY","ALTER TABLE product_boms ENABLE ROW LEVEL SECURITY","ALTER TABLE bom_items ENABLE ROW LEVEL SECURITY","-- 为所有表创建基本的策略（MVP: 所有已认证用户可以访问）\n-- 在未来可以基于 users.is_admin 或其他角色来细化权限\n\n-- Entity Type Nodes\nCREATE POLICY \\"Authenticated users can view entity_type_nodes\\" ON entity_type_nodes\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert entity_type_nodes\\" ON entity_type_nodes\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update entity_type_nodes\\" ON entity_type_nodes\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete entity_type_nodes\\" ON entity_type_nodes\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Attribute Definitions\nCREATE POLICY \\"Authenticated users can view attribute_definitions\\" ON attribute_definitions\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert attribute_definitions\\" ON attribute_definitions\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update attribute_definitions\\" ON attribute_definitions\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete attribute_definitions\\" ON attribute_definitions\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Users\nCREATE POLICY \\"Authenticated users can view users\\" ON users\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert users\\" ON users\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update users\\" ON users\n  FOR UPDATE USING (auth.role() = 'authenticated')","-- Seasons\nCREATE POLICY \\"Authenticated users can view seasons\\" ON seasons\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert seasons\\" ON seasons\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update seasons\\" ON seasons\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete seasons\\" ON seasons\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Products\nCREATE POLICY \\"Authenticated users can view products\\" ON products\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert products\\" ON products\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update products\\" ON products\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete products\\" ON products\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Materials\nCREATE POLICY \\"Authenticated users can view materials\\" ON materials\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert materials\\" ON materials\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update materials\\" ON materials\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete materials\\" ON materials\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Suppliers\nCREATE POLICY \\"Authenticated users can view suppliers\\" ON suppliers\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert suppliers\\" ON suppliers\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update suppliers\\" ON suppliers\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete suppliers\\" ON suppliers\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Colors\nCREATE POLICY \\"Authenticated users can view colors\\" ON colors\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert colors\\" ON colors\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update colors\\" ON colors\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete colors\\" ON colors\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Material Suppliers\nCREATE POLICY \\"Authenticated users can view material_suppliers\\" ON material_suppliers\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert material_suppliers\\" ON material_suppliers\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update material_suppliers\\" ON material_suppliers\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete material_suppliers\\" ON material_suppliers\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Material Colors\nCREATE POLICY \\"Authenticated users can view material_colors\\" ON material_colors\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert material_colors\\" ON material_colors\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update material_colors\\" ON material_colors\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete material_colors\\" ON material_colors\n  FOR DELETE USING (auth.role() = 'authenticated')","-- Product BOMs\nCREATE POLICY \\"Authenticated users can view product_boms\\" ON product_boms\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert product_boms\\" ON product_boms\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update product_boms\\" ON product_boms\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete product_boms\\" ON product_boms\n  FOR DELETE USING (auth.role() = 'authenticated')","-- BOM Items\nCREATE POLICY \\"Authenticated users can view bom_items\\" ON bom_items\n  FOR SELECT USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can insert bom_items\\" ON bom_items\n  FOR INSERT WITH CHECK (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can update bom_items\\" ON bom_items\n  FOR UPDATE USING (auth.role() = 'authenticated')","CREATE POLICY \\"Authenticated users can delete bom_items\\" ON bom_items\n  FOR DELETE USING (auth.role() = 'authenticated')","-- =====================================================\n-- 完成\n-- ====================================================="}	initial_schema
20250108000001	{"-- 创建触发器函数：当 auth.users 中创建新用户时，自动在 public.users 中创建记录\nCREATE OR REPLACE FUNCTION public.handle_new_user()\nRETURNS TRIGGER AS $$\nBEGIN\n  INSERT INTO public.users (id, email, display_name, is_admin, created_at, updated_at)\n  VALUES (\n    NEW.id,\n    NEW.email,\n    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),\n    FALSE,\n    NOW(),\n    NOW()\n  );\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- 创建触发器：在 auth.users 插入新记录后自动执行\nCREATE TRIGGER on_auth_user_created\n  AFTER INSERT ON auth.users\n  FOR EACH ROW\n  EXECUTE FUNCTION public.handle_new_user()","-- 同步现有的 auth.users 到 public.users（如果有的话）\nINSERT INTO public.users (id, email, display_name, is_admin, created_at, updated_at)\nSELECT\n  id,\n  email,\n  COALESCE(raw_user_meta_data->>'display_name', email) as display_name,\n  FALSE as is_admin,\n  created_at,\n  updated_at\nFROM auth.users\nWHERE id NOT IN (SELECT id FROM public.users)\nON CONFLICT (id) DO NOTHING"}	user_sync_trigger
20250108000002	{"-- FlexLite PLM Enums Table Migration\n-- 创建枚举管理表，用于动态管理系统枚举值\n\n-- =====================================================\n-- 1. 创建 enums 表\n-- =====================================================\nCREATE TABLE enums (\n  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),\n  enum_type VARCHAR(50) NOT NULL,           -- 枚举类型，如 'season_status', 'product_status'\n  enum_value VARCHAR(100) NOT NULL,         -- 枚举值\n  label VARCHAR(255) NOT NULL,              -- 显示标签（用于UI）\n  order_index INTEGER NOT NULL DEFAULT 0,   -- 排序顺序\n  is_active BOOLEAN NOT NULL DEFAULT TRUE,  -- 是否启用\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n\n  -- 确保同一类型的枚举值唯一\n  UNIQUE(enum_type, enum_value)\n)","-- 索引\nCREATE INDEX idx_enums_enum_type ON enums(enum_type)","CREATE INDEX idx_enums_is_active ON enums(is_active)","-- =====================================================\n-- 2. 从 PostgreSQL ENUM 类型初始化数据\n-- =====================================================\n\n-- Season Status\nINSERT INTO enums (enum_type, enum_value, label, order_index) VALUES\n  ('season_status', 'planned', 'Planned', 1),\n  ('season_status', 'active', 'Active', 2),\n  ('season_status', 'archived', 'Archived', 3)","-- Product Status\nINSERT INTO enums (enum_type, enum_value, label, order_index) VALUES\n  ('product_status', 'development', 'Development', 1),\n  ('product_status', 'pre-production', 'Pre-Production', 2),\n  ('product_status', 'production', 'Production', 3),\n  ('product_status', 'inactive', 'Inactive', 4)","-- Product Gender\nINSERT INTO enums (enum_type, enum_value, label, order_index) VALUES\n  ('product_gender', 'unisex', 'Unisex', 1),\n  ('product_gender', 'women', 'Women', 2),\n  ('product_gender', 'men', 'Men', 3),\n  ('product_gender', 'kids', 'Kids', 4)","-- Material Status\nINSERT INTO enums (enum_type, enum_value, label, order_index) VALUES\n  ('material_status', 'in_development', 'In Development', 1),\n  ('material_status', 'active', 'Active', 2),\n  ('material_status', 'dropped', 'Dropped', 3),\n  ('material_status', 'rfq', 'RFQ', 4)","-- Supplier Status\nINSERT INTO enums (enum_type, enum_value, label, order_index) VALUES\n  ('supplier_status', 'active', 'Active', 1),\n  ('supplier_status', 'inactive', 'Inactive', 2)","-- Color Status\nINSERT INTO enums (enum_type, enum_value, label, order_index) VALUES\n  ('color_status', 'active', 'Active', 1),\n  ('color_status', 'inactive', 'Inactive', 2)","-- BOM Status\nINSERT INTO enums (enum_type, enum_value, label, order_index) VALUES\n  ('bom_status', 'draft', 'Draft', 1),\n  ('bom_status', 'active', 'Active', 2),\n  ('bom_status', 'archived', 'Archived', 3)","-- =====================================================\n-- 3. 更新触发器（自动更新 updated_at）\n-- =====================================================\nCREATE OR REPLACE FUNCTION update_enums_updated_at()\nRETURNS TRIGGER AS $$\nBEGIN\n  NEW.updated_at = NOW();\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql","CREATE TRIGGER trigger_update_enums_updated_at\n  BEFORE UPDATE ON enums\n  FOR EACH ROW\n  EXECUTE FUNCTION update_enums_updated_at()","-- =====================================================\n-- 4. RLS (Row Level Security) 策略\n-- =====================================================\nALTER TABLE enums ENABLE ROW LEVEL SECURITY","-- 所有用户可以读取枚举\nCREATE POLICY \\"枚举表所有用户可读\\"\n  ON enums FOR SELECT\n  TO authenticated\n  USING (true)","-- 只有管理员可以修改枚举\nCREATE POLICY \\"枚举表仅管理员可修改\\"\n  ON enums FOR ALL\n  TO authenticated\n  USING (\n    EXISTS (\n      SELECT 1 FROM users\n      WHERE users.id = auth.uid()\n      AND users.is_admin = TRUE\n    )\n  )","-- =====================================================\n-- 5. 辅助函数：获取枚举值列表\n-- =====================================================\nCREATE OR REPLACE FUNCTION get_enum_values(p_enum_type VARCHAR)\nRETURNS TABLE(enum_value VARCHAR, label VARCHAR) AS $$\nBEGIN\n  RETURN QUERY\n  SELECT e.enum_value, e.label\n  FROM enums e\n  WHERE e.enum_type = p_enum_type\n    AND e.is_active = TRUE\n  ORDER BY e.order_index, e.enum_value;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","COMMENT ON TABLE enums IS '系统枚举值管理表，用于动态管理各种状态和选项'","COMMENT ON FUNCTION get_enum_values IS '获取指定类型的所有活跃枚举值'"}	create_enums_table
20250108000003	{"-- 添加 delisting 状态到 product_status_enum\n-- 这个迁移允许 PostgreSQL ENUM 接受 delisting 值\n\nALTER TYPE product_status_enum ADD VALUE IF NOT EXISTS 'delisting'","-- 注意：PostgreSQL ENUM 值只能添加，不能删除或重命名\n-- 如果需要删除或重命名，必须重建整个 ENUM 类型"}	add_delisting_to_product_status
20250108000004	{"-- 将所有实体表的 status 字段从 ENUM 类型改为 TEXT\n-- 这样就完全依赖 enums 表管理枚举值，实现真正的动态枚举\n\n-- =====================================================\n-- 1. Seasons 表\n-- =====================================================\n-- 修改 status 字段为 TEXT\nALTER TABLE seasons\n  ALTER COLUMN status TYPE TEXT","-- 添加注释\nCOMMENT ON COLUMN seasons.status IS 'Status of the season. Valid values are managed in the enums table (enum_type=season_status)'","-- =====================================================\n-- 2. Products 表\n-- =====================================================\n-- 修改 status 字段为 TEXT\nALTER TABLE products\n  ALTER COLUMN status TYPE TEXT","-- 修改 gender 字段为 TEXT\nALTER TABLE products\n  ALTER COLUMN gender TYPE TEXT","-- 添加注释\nCOMMENT ON COLUMN products.status IS 'Status of the product. Valid values are managed in the enums table (enum_type=product_status)'","COMMENT ON COLUMN products.gender IS 'Gender category. Valid values are managed in the enums table (enum_type=product_gender)'","-- =====================================================\n-- 3. Materials 表\n-- =====================================================\n-- 修改 status 字段为 TEXT\nALTER TABLE materials\n  ALTER COLUMN status TYPE TEXT","COMMENT ON COLUMN materials.status IS 'Status of the material. Valid values are managed in the enums table (enum_type=material_status)'","-- =====================================================\n-- 4. Suppliers 表\n-- =====================================================\n-- 修改 status 字段为 TEXT\nALTER TABLE suppliers\n  ALTER COLUMN status TYPE TEXT","COMMENT ON COLUMN suppliers.status IS 'Status of the supplier. Valid values are managed in the enums table (enum_type=supplier_status)'","-- =====================================================\n-- 5. Colors 表\n-- =====================================================\n-- 修改 status 字段为 TEXT\nALTER TABLE colors\n  ALTER COLUMN status TYPE TEXT","COMMENT ON COLUMN colors.status IS 'Status of the color. Valid values are managed in the enums table (enum_type=color_status)'","-- =====================================================\n-- 6. Product BOMs 表\n-- =====================================================\n-- 修改 status 字段为 TEXT\nALTER TABLE product_boms\n  ALTER COLUMN status TYPE TEXT","COMMENT ON COLUMN product_boms.status IS 'Status of the BOM. Valid values are managed in the enums table (enum_type=bom_status)'","-- =====================================================\n-- 注意事项\n-- =====================================================\n-- 1. PostgreSQL ENUM 类型仍然存在，但不再被使用\n-- 2. 如需删除这些 ENUM 类型，需要确保没有其他依赖\n-- 3. 应用层（Server Actions）会继续验证枚举值的有效性\n-- 4. 现在可以通过 enums 表的 UI 完全管理所有枚举值，无需 SQL 迁移\n\n-- =====================================================\n-- 可选：删除未使用的 ENUM 类型（谨慎操作）\n-- =====================================================\n-- 以下语句被注释，如果确认没有其他依赖可以取消注释执行\n-- DROP TYPE IF EXISTS season_status_enum;\n-- DROP TYPE IF EXISTS product_status_enum;\n-- DROP TYPE IF EXISTS material_status_enum;\n-- DROP TYPE IF EXISTS supplier_status_enum;\n-- DROP TYPE IF EXISTS color_status_enum;\n-- DROP TYPE IF EXISTS bom_status_enum;"}	convert_enums_to_text
20250108000005	{"-- Add versioning columns to products, materials, and suppliers tables\n\nALTER TABLE products\n  ADD COLUMN IF NOT EXISTS version CHAR(1) NOT NULL DEFAULT 'A',\n  ADD COLUMN IF NOT EXISTS iteration SMALLINT NOT NULL DEFAULT 1","ALTER TABLE products\n  ADD CONSTRAINT products_version_check CHECK (version ~ '^[A-Z]$'),\n  ADD CONSTRAINT products_iteration_check CHECK (iteration BETWEEN 1 AND 999)","ALTER TABLE materials\n  ADD COLUMN IF NOT EXISTS version CHAR(1) NOT NULL DEFAULT 'A',\n  ADD COLUMN IF NOT EXISTS iteration SMALLINT NOT NULL DEFAULT 1","ALTER TABLE materials\n  ADD CONSTRAINT materials_version_check CHECK (version ~ '^[A-Z]$'),\n  ADD CONSTRAINT materials_iteration_check CHECK (iteration BETWEEN 1 AND 999)","ALTER TABLE suppliers\n  ADD COLUMN IF NOT EXISTS version CHAR(1) NOT NULL DEFAULT 'A',\n  ADD COLUMN IF NOT EXISTS iteration SMALLINT NOT NULL DEFAULT 1","ALTER TABLE suppliers\n  ADD CONSTRAINT suppliers_version_check CHECK (version ~ '^[A-Z]$'),\n  ADD CONSTRAINT suppliers_iteration_check CHECK (iteration BETWEEN 1 AND 999)"}	add_versioning_columns
20250108000006	{"-- Add create_by and update_by columns to all core entity tables\n\nALTER TABLE products\n  ADD COLUMN IF NOT EXISTS create_by TEXT,\n  ADD COLUMN IF NOT EXISTS update_by TEXT","ALTER TABLE materials\n  ADD COLUMN IF NOT EXISTS create_by TEXT,\n  ADD COLUMN IF NOT EXISTS update_by TEXT","ALTER TABLE suppliers\n  ADD COLUMN IF NOT EXISTS create_by TEXT,\n  ADD COLUMN IF NOT EXISTS update_by TEXT","ALTER TABLE seasons\n  ADD COLUMN IF NOT EXISTS create_by TEXT,\n  ADD COLUMN IF NOT EXISTS update_by TEXT","ALTER TABLE colors\n  ADD COLUMN IF NOT EXISTS create_by TEXT,\n  ADD COLUMN IF NOT EXISTS update_by TEXT"}	add_create_update_by_columns
20250109000001	{"-- Migration: Refactor Version Control System\n-- Add isLatest field and update constraints for version-controlled entities\n\n-- =====================================================\n-- 1. Add isLatest column to versioned entities\n-- =====================================================\n\n-- Products\nALTER TABLE products\nADD COLUMN IF NOT EXISTS is_latest BOOLEAN NOT NULL DEFAULT TRUE","CREATE INDEX IF NOT EXISTS idx_products_latest\nON products(style_code, is_latest)\nWHERE is_latest = TRUE","-- Materials\nALTER TABLE materials\nADD COLUMN IF NOT EXISTS is_latest BOOLEAN NOT NULL DEFAULT TRUE","CREATE INDEX IF NOT EXISTS idx_materials_latest\nON materials(material_code, is_latest)\nWHERE is_latest = TRUE","-- Suppliers\nALTER TABLE suppliers\nADD COLUMN IF NOT EXISTS is_latest BOOLEAN NOT NULL DEFAULT TRUE","CREATE INDEX IF NOT EXISTS idx_suppliers_latest\nON suppliers(supplier_code, is_latest)\nWHERE is_latest = TRUE","-- =====================================================\n-- 2. Drop UNIQUE constraints on code fields\n--    (since we now have multiple versions per code)\n-- =====================================================\n\n-- Products: Drop unique constraint on style_code\nALTER TABLE products\nDROP CONSTRAINT IF EXISTS products_style_code_key","-- Materials: Drop unique constraint on material_code\nALTER TABLE materials\nDROP CONSTRAINT IF EXISTS materials_material_code_key","-- Suppliers: Drop unique constraint on supplier_code\nALTER TABLE suppliers\nDROP CONSTRAINT IF EXISTS suppliers_supplier_code_key","-- =====================================================\n-- 3. Add composite unique constraints\n--    (code + version + iteration must be unique)\n-- =====================================================\n\n-- Products\nALTER TABLE products\nADD CONSTRAINT products_code_version_iteration_unique\nUNIQUE (style_code, version, iteration)","-- Materials\nALTER TABLE materials\nADD CONSTRAINT materials_code_version_iteration_unique\nUNIQUE (material_code, version, iteration)","-- Suppliers\nALTER TABLE suppliers\nADD CONSTRAINT suppliers_code_version_iteration_unique\nUNIQUE (supplier_code, version, iteration)","-- =====================================================\n-- 4. Add constraint: only one latest version per code\n-- =====================================================\n\n-- Products: Only one row can be latest for each style_code\nCREATE UNIQUE INDEX IF NOT EXISTS idx_products_one_latest_per_code\nON products(style_code)\nWHERE is_latest = TRUE","-- Materials: Only one row can be latest for each material_code\nCREATE UNIQUE INDEX IF NOT EXISTS idx_materials_one_latest_per_code\nON materials(material_code)\nWHERE is_latest = TRUE","-- Suppliers: Only one row can be latest for each supplier_code\nCREATE UNIQUE INDEX IF NOT EXISTS idx_suppliers_one_latest_per_code\nON suppliers(supplier_code)\nWHERE is_latest = TRUE","-- =====================================================\n-- 5. Update existing records to set isLatest\n--    (For each code, mark the highest iteration as latest)\n-- =====================================================\n\n-- Products: Mark latest versions\nWITH latest_products AS (\n  SELECT DISTINCT ON (style_code)\n    id\n  FROM products\n  ORDER BY style_code, version DESC, iteration DESC\n)\nUPDATE products\nSET is_latest = (id IN (SELECT id FROM latest_products))","-- Materials: Mark latest versions\nWITH latest_materials AS (\n  SELECT DISTINCT ON (material_code)\n    id\n  FROM materials\n  ORDER BY material_code, version DESC, iteration DESC\n)\nUPDATE materials\nSET is_latest = (id IN (SELECT id FROM latest_materials))","-- Suppliers: Mark latest versions\nWITH latest_suppliers AS (\n  SELECT DISTINCT ON (supplier_code)\n    id\n  FROM suppliers\n  ORDER BY supplier_code, version DESC, iteration DESC\n)\nUPDATE suppliers\nSET is_latest = (id IN (SELECT id FROM latest_suppliers))","-- =====================================================\n-- 6. Create helper function to get latest version ID\n-- =====================================================\n\nCREATE OR REPLACE FUNCTION get_latest_version_id(\n  p_table_name TEXT,\n  p_code_field TEXT,\n  p_code_value TEXT\n)\nRETURNS UUID AS $$\nDECLARE\n  v_id UUID;\n  v_query TEXT;\nBEGIN\n  v_query := format(\n    'SELECT id FROM %I WHERE %I = $1 AND is_latest = TRUE LIMIT 1',\n    p_table_name,\n    p_code_field\n  );\n\n  EXECUTE v_query INTO v_id USING p_code_value;\n\n  RETURN v_id;\nEND;\n$$ LANGUAGE plpgsql SECURITY DEFINER","-- =====================================================\n-- 7. Add comments for documentation\n-- =====================================================\n\nCOMMENT ON COLUMN products.is_latest IS 'Indicates if this is the current/latest version of the product. Only one version per style_code can be latest.'","COMMENT ON COLUMN products.version IS 'Major version letter (A-Z). Currently only A is used.'","COMMENT ON COLUMN products.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)'","COMMENT ON COLUMN materials.is_latest IS 'Indicates if this is the current/latest version of the material. Only one version per material_code can be latest.'","COMMENT ON COLUMN materials.version IS 'Major version letter (A-Z). Currently only A is used.'","COMMENT ON COLUMN materials.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)'","COMMENT ON COLUMN suppliers.is_latest IS 'Indicates if this is the current/latest version of the supplier. Only one version per supplier_code can be latest.'","COMMENT ON COLUMN suppliers.version IS 'Major version letter (A-Z). Currently only A is used.'","COMMENT ON COLUMN suppliers.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)'"}	refactor_version_control
20250109000002	{"-- Migration: Create Master Tables for Version-Controlled Entities\n-- Separates item identity (master) from version data (detail)\n\n-- =====================================================\n-- 1. Create Master Tables\n-- =====================================================\n\n-- Product Master: Unique style codes\nCREATE TABLE IF NOT EXISTS product_master (\n  style_code VARCHAR PRIMARY KEY,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  created_by TEXT NOT NULL,\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- Material Master: Unique material codes\nCREATE TABLE IF NOT EXISTS material_master (\n  material_code VARCHAR PRIMARY KEY,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  created_by TEXT NOT NULL,\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- Supplier Master: Unique supplier codes\nCREATE TABLE IF NOT EXISTS supplier_master (\n  supplier_code VARCHAR PRIMARY KEY,\n  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),\n  created_by TEXT NOT NULL,\n  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()\n)","-- =====================================================\n-- 2. Add Foreign Key Constraints\n-- =====================================================\n\n-- Products table: Reference product_master\nALTER TABLE products\n  DROP CONSTRAINT IF EXISTS products_code_version_iteration_unique","ALTER TABLE products\n  ADD CONSTRAINT fk_products_master\n  FOREIGN KEY (style_code)\n  REFERENCES product_master(style_code)\n  ON DELETE CASCADE","-- Keep composite unique on (code, version, iteration)\nALTER TABLE products\n  ADD CONSTRAINT products_code_version_iteration_unique\n  UNIQUE (style_code, version, iteration)","-- Materials table: Reference material_master\nALTER TABLE materials\n  DROP CONSTRAINT IF EXISTS materials_code_version_iteration_unique","ALTER TABLE materials\n  ADD CONSTRAINT fk_materials_master\n  FOREIGN KEY (material_code)\n  REFERENCES material_master(material_code)\n  ON DELETE CASCADE","ALTER TABLE materials\n  ADD CONSTRAINT materials_code_version_iteration_unique\n  UNIQUE (material_code, version, iteration)","-- Suppliers table: Reference supplier_master\nALTER TABLE suppliers\n  DROP CONSTRAINT IF EXISTS suppliers_code_version_iteration_unique","ALTER TABLE suppliers\n  ADD CONSTRAINT fk_suppliers_master\n  FOREIGN KEY (supplier_code)\n  REFERENCES supplier_master(supplier_code)\n  ON DELETE CASCADE","ALTER TABLE suppliers\n  ADD CONSTRAINT suppliers_code_version_iteration_unique\n  UNIQUE (supplier_code, version, iteration)","-- =====================================================\n-- 3. Migrate Existing Data to Master Tables\n-- =====================================================\n\n-- Product Master: Insert distinct style codes\nINSERT INTO product_master (style_code, created_at, created_by)\nSELECT DISTINCT ON (style_code)\n  style_code,\n  created_at,\n  COALESCE(create_by, 'system') as created_by\nFROM products\nWHERE style_code IS NOT NULL\nORDER BY style_code, created_at ASC\nON CONFLICT (style_code) DO NOTHING","-- Material Master: Insert distinct material codes\nINSERT INTO material_master (material_code, created_at, created_by)\nSELECT DISTINCT ON (material_code)\n  material_code,\n  created_at,\n  COALESCE(create_by, 'system') as created_by\nFROM materials\nWHERE material_code IS NOT NULL\nORDER BY material_code, created_at ASC\nON CONFLICT (material_code) DO NOTHING","-- Supplier Master: Insert distinct supplier codes\nINSERT INTO supplier_master (supplier_code, created_at, created_by)\nSELECT DISTINCT ON (supplier_code)\n  supplier_code,\n  created_at,\n  COALESCE(create_by, 'system') as created_by\nFROM suppliers\nWHERE supplier_code IS NOT NULL\nORDER BY supplier_code, created_at ASC\nON CONFLICT (supplier_code) DO NOTHING","-- =====================================================\n-- 4. Create Indexes for Performance\n-- =====================================================\n\n-- Master tables indexes (already primary keys, but explicit for clarity)\nCREATE INDEX IF NOT EXISTS idx_product_master_created_at\n  ON product_master(created_at DESC)","CREATE INDEX IF NOT EXISTS idx_material_master_created_at\n  ON material_master(created_at DESC)","CREATE INDEX IF NOT EXISTS idx_supplier_master_created_at\n  ON supplier_master(created_at DESC)","-- Detail tables: Index on code for JOIN performance\nCREATE INDEX IF NOT EXISTS idx_products_style_code_latest\n  ON products(style_code, is_latest) WHERE is_latest = TRUE","CREATE INDEX IF NOT EXISTS idx_materials_code_latest\n  ON materials(material_code, is_latest) WHERE is_latest = TRUE","CREATE INDEX IF NOT EXISTS idx_suppliers_code_latest\n  ON suppliers(supplier_code, is_latest) WHERE is_latest = TRUE","-- =====================================================\n-- 5. Create Views for Convenient Querying\n-- =====================================================\n\n-- View: Latest Products with Master info\nCREATE OR REPLACE VIEW products_latest AS\nSELECT\n  p.*,\n  pm.created_at as master_created_at,\n  pm.created_by as master_created_by\nFROM product_master pm\nINNER JOIN products p ON pm.style_code = p.style_code\nWHERE p.is_latest = TRUE","-- View: Latest Materials with Master info\nCREATE OR REPLACE VIEW materials_latest AS\nSELECT\n  m.*,\n  mm.created_at as master_created_at,\n  mm.created_by as master_created_by\nFROM material_master mm\nINNER JOIN materials m ON mm.material_code = m.material_code\nWHERE m.is_latest = TRUE","-- View: Latest Suppliers with Master info\nCREATE OR REPLACE VIEW suppliers_latest AS\nSELECT\n  s.*,\n  sm.created_at as master_created_at,\n  sm.created_by as master_created_by\nFROM supplier_master sm\nINNER JOIN suppliers s ON sm.supplier_code = s.supplier_code\nWHERE s.is_latest = TRUE","-- =====================================================\n-- 6. Enable Row Level Security (RLS)\n-- =====================================================\n\n-- Enable RLS on master tables\nALTER TABLE product_master ENABLE ROW LEVEL SECURITY","ALTER TABLE material_master ENABLE ROW LEVEL SECURITY","ALTER TABLE supplier_master ENABLE ROW LEVEL SECURITY","-- Create policies (allow authenticated users to read/write)\n-- Product Master\nCREATE POLICY \\"Enable read access for authenticated users on product_master\\"\n  ON product_master FOR SELECT\n  TO authenticated\n  USING (true)","CREATE POLICY \\"Enable insert for authenticated users on product_master\\"\n  ON product_master FOR INSERT\n  TO authenticated\n  WITH CHECK (true)","CREATE POLICY \\"Enable update for authenticated users on product_master\\"\n  ON product_master FOR UPDATE\n  TO authenticated\n  USING (true)","-- Material Master\nCREATE POLICY \\"Enable read access for authenticated users on material_master\\"\n  ON material_master FOR SELECT\n  TO authenticated\n  USING (true)","CREATE POLICY \\"Enable insert for authenticated users on material_master\\"\n  ON material_master FOR INSERT\n  TO authenticated\n  WITH CHECK (true)","CREATE POLICY \\"Enable update for authenticated users on material_master\\"\n  ON material_master FOR UPDATE\n  TO authenticated\n  USING (true)","-- Supplier Master\nCREATE POLICY \\"Enable read access for authenticated users on supplier_master\\"\n  ON supplier_master FOR SELECT\n  TO authenticated\n  USING (true)","CREATE POLICY \\"Enable insert for authenticated users on supplier_master\\"\n  ON supplier_master FOR INSERT\n  TO authenticated\n  WITH CHECK (true)","CREATE POLICY \\"Enable update for authenticated users on supplier_master\\"\n  ON supplier_master FOR UPDATE\n  TO authenticated\n  USING (true)","-- =====================================================\n-- 7. Add Triggers to Update updated_at\n-- =====================================================\n\n-- Trigger function to update updated_at\nCREATE OR REPLACE FUNCTION update_master_updated_at()\nRETURNS TRIGGER AS $$\nBEGIN\n  NEW.updated_at = NOW();\n  RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql","-- Product Master trigger\nDROP TRIGGER IF EXISTS set_product_master_updated_at ON product_master","CREATE TRIGGER set_product_master_updated_at\n  BEFORE UPDATE ON product_master\n  FOR EACH ROW\n  EXECUTE FUNCTION update_master_updated_at()","-- Material Master trigger\nDROP TRIGGER IF EXISTS set_material_master_updated_at ON material_master","CREATE TRIGGER set_material_master_updated_at\n  BEFORE UPDATE ON material_master\n  FOR EACH ROW\n  EXECUTE FUNCTION update_master_updated_at()","-- Supplier Master trigger\nDROP TRIGGER IF EXISTS set_supplier_master_updated_at ON supplier_master","CREATE TRIGGER set_supplier_master_updated_at\n  BEFORE UPDATE ON supplier_master\n  FOR EACH ROW\n  EXECUTE FUNCTION update_master_updated_at()","-- =====================================================\n-- 8. Add Comments for Documentation\n-- =====================================================\n\nCOMMENT ON TABLE product_master IS 'Master table for products. Each style_code appears exactly once. Contains item identity and creation metadata.'","COMMENT ON TABLE material_master IS 'Master table for materials. Each material_code appears exactly once. Contains item identity and creation metadata.'","COMMENT ON TABLE supplier_master IS 'Master table for suppliers. Each supplier_code appears exactly once. Contains item identity and creation metadata.'","COMMENT ON COLUMN product_master.style_code IS 'Unique product identifier. Primary key. Referenced by products table versions.'","COMMENT ON COLUMN material_master.material_code IS 'Unique material identifier. Primary key. Referenced by materials table versions.'","COMMENT ON COLUMN supplier_master.supplier_code IS 'Unique supplier identifier. Primary key. Referenced by suppliers table versions.'","COMMENT ON VIEW products_latest IS 'Convenient view joining product_master with latest version from products table.'","COMMENT ON VIEW materials_latest IS 'Convenient view joining material_master with latest version from materials table.'","COMMENT ON VIEW suppliers_latest IS 'Convenient view joining supplier_master with latest version from suppliers table.'"}	create_master_tables
\.


--
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
supabase/seed.sql	e735f09837acc9ed39aa45ee902e8ab2c253fbfc680e82eea9588a247ea2f300
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: attribute_definitions attribute_definitions_entity_type_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attribute_definitions
    ADD CONSTRAINT attribute_definitions_entity_type_key_key UNIQUE (entity_type, key);


--
-- Name: attribute_definitions attribute_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attribute_definitions
    ADD CONSTRAINT attribute_definitions_pkey PRIMARY KEY (id);


--
-- Name: bom_items bom_items_bom_id_line_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bom_items
    ADD CONSTRAINT bom_items_bom_id_line_number_key UNIQUE (bom_id, line_number);


--
-- Name: bom_items bom_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bom_items
    ADD CONSTRAINT bom_items_pkey PRIMARY KEY (id);


--
-- Name: colors colors_color_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colors
    ADD CONSTRAINT colors_color_code_key UNIQUE (color_code);


--
-- Name: colors colors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colors
    ADD CONSTRAINT colors_pkey PRIMARY KEY (id);


--
-- Name: entity_type_nodes entity_type_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_type_nodes
    ADD CONSTRAINT entity_type_nodes_pkey PRIMARY KEY (id);


--
-- Name: enums enums_enum_type_enum_value_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enums
    ADD CONSTRAINT enums_enum_type_enum_value_key UNIQUE (enum_type, enum_value);


--
-- Name: enums enums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enums
    ADD CONSTRAINT enums_pkey PRIMARY KEY (id);


--
-- Name: material_colors material_colors_material_id_color_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_colors
    ADD CONSTRAINT material_colors_material_id_color_id_key UNIQUE (material_id, color_id);


--
-- Name: material_colors material_colors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_colors
    ADD CONSTRAINT material_colors_pkey PRIMARY KEY (id);


--
-- Name: material_master material_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_master
    ADD CONSTRAINT material_master_pkey PRIMARY KEY (material_code);


--
-- Name: material_suppliers material_suppliers_material_id_supplier_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_suppliers
    ADD CONSTRAINT material_suppliers_material_id_supplier_id_key UNIQUE (material_id, supplier_id);


--
-- Name: material_suppliers material_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_suppliers
    ADD CONSTRAINT material_suppliers_pkey PRIMARY KEY (id);


--
-- Name: materials materials_code_version_iteration_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_code_version_iteration_unique UNIQUE (material_code, version, iteration);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: product_boms product_boms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_boms
    ADD CONSTRAINT product_boms_pkey PRIMARY KEY (id);


--
-- Name: product_master product_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_master
    ADD CONSTRAINT product_master_pkey PRIMARY KEY (style_code);


--
-- Name: products products_code_version_iteration_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_code_version_iteration_unique UNIQUE (style_code, version, iteration);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: seasons seasons_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_code_key UNIQUE (code);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: supplier_master supplier_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier_master
    ADD CONSTRAINT supplier_master_pkey PRIMARY KEY (supplier_code);


--
-- Name: suppliers suppliers_code_version_iteration_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_code_version_iteration_unique UNIQUE (supplier_code, version, iteration);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_11_08 messages_2025_11_08_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_11_08
    ADD CONSTRAINT messages_2025_11_08_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_11_09 messages_2025_11_09_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_11_09
    ADD CONSTRAINT messages_2025_11_09_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_11_10 messages_2025_11_10_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_11_10
    ADD CONSTRAINT messages_2025_11_10_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_11_11 messages_2025_11_11_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_11_11
    ADD CONSTRAINT messages_2025_11_11_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_11_12 messages_2025_11_12_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2025_11_12
    ADD CONSTRAINT messages_2025_11_12_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_attribute_definitions_entity_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attribute_definitions_entity_type ON public.attribute_definitions USING btree (entity_type);


--
-- Name: idx_attribute_definitions_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attribute_definitions_is_active ON public.attribute_definitions USING btree (is_active);


--
-- Name: idx_bom_items_bom_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bom_items_bom_id ON public.bom_items USING btree (bom_id);


--
-- Name: idx_bom_items_color_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bom_items_color_id ON public.bom_items USING btree (color_id);


--
-- Name: idx_bom_items_material_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bom_items_material_id ON public.bom_items USING btree (material_id);


--
-- Name: idx_bom_items_supplier_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bom_items_supplier_id ON public.bom_items USING btree (supplier_id);


--
-- Name: idx_colors_color_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_colors_color_code ON public.colors USING btree (color_code);


--
-- Name: idx_colors_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_colors_status ON public.colors USING btree (status);


--
-- Name: idx_colors_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_colors_type_id ON public.colors USING btree (type_id);


--
-- Name: idx_entity_type_nodes_entity_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_entity_type_nodes_entity_type ON public.entity_type_nodes USING btree (entity_type);


--
-- Name: idx_entity_type_nodes_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_entity_type_nodes_parent_id ON public.entity_type_nodes USING btree (parent_id);


--
-- Name: idx_enums_enum_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_enums_enum_type ON public.enums USING btree (enum_type);


--
-- Name: idx_enums_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_enums_is_active ON public.enums USING btree (is_active);


--
-- Name: idx_material_colors_color_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_material_colors_color_id ON public.material_colors USING btree (color_id);


--
-- Name: idx_material_colors_material_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_material_colors_material_id ON public.material_colors USING btree (material_id);


--
-- Name: idx_material_master_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_material_master_created_at ON public.material_master USING btree (created_at DESC);


--
-- Name: idx_material_suppliers_material_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_material_suppliers_material_id ON public.material_suppliers USING btree (material_id);


--
-- Name: idx_material_suppliers_supplier_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_material_suppliers_supplier_id ON public.material_suppliers USING btree (supplier_id);


--
-- Name: idx_materials_code_latest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_code_latest ON public.materials USING btree (material_code, is_latest) WHERE (is_latest = true);


--
-- Name: idx_materials_latest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_latest ON public.materials USING btree (material_code, is_latest) WHERE (is_latest = true);


--
-- Name: idx_materials_material_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_material_code ON public.materials USING btree (material_code);


--
-- Name: idx_materials_one_latest_per_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_materials_one_latest_per_code ON public.materials USING btree (material_code) WHERE (is_latest = true);


--
-- Name: idx_materials_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_status ON public.materials USING btree (status);


--
-- Name: idx_materials_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_materials_type_id ON public.materials USING btree (type_id);


--
-- Name: idx_product_boms_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_boms_product_id ON public.product_boms USING btree (product_id);


--
-- Name: idx_product_boms_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_boms_status ON public.product_boms USING btree (status);


--
-- Name: idx_product_master_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_master_created_at ON public.product_master USING btree (created_at DESC);


--
-- Name: idx_products_latest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_latest ON public.products USING btree (style_code, is_latest) WHERE (is_latest = true);


--
-- Name: idx_products_one_latest_per_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_products_one_latest_per_code ON public.products USING btree (style_code) WHERE (is_latest = true);


--
-- Name: idx_products_season_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_season_id ON public.products USING btree (season_id);


--
-- Name: idx_products_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_status ON public.products USING btree (status);


--
-- Name: idx_products_style_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_style_code ON public.products USING btree (style_code);


--
-- Name: idx_products_style_code_latest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_style_code_latest ON public.products USING btree (style_code, is_latest) WHERE (is_latest = true);


--
-- Name: idx_products_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_type_id ON public.products USING btree (type_id);


--
-- Name: idx_seasons_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seasons_code ON public.seasons USING btree (code);


--
-- Name: idx_seasons_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seasons_status ON public.seasons USING btree (status);


--
-- Name: idx_seasons_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seasons_type_id ON public.seasons USING btree (type_id);


--
-- Name: idx_seasons_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_seasons_year ON public.seasons USING btree (year);


--
-- Name: idx_supplier_master_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_supplier_master_created_at ON public.supplier_master USING btree (created_at DESC);


--
-- Name: idx_suppliers_code_latest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_suppliers_code_latest ON public.suppliers USING btree (supplier_code, is_latest) WHERE (is_latest = true);


--
-- Name: idx_suppliers_latest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_suppliers_latest ON public.suppliers USING btree (supplier_code, is_latest) WHERE (is_latest = true);


--
-- Name: idx_suppliers_one_latest_per_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_suppliers_one_latest_per_code ON public.suppliers USING btree (supplier_code) WHERE (is_latest = true);


--
-- Name: idx_suppliers_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_suppliers_status ON public.suppliers USING btree (status);


--
-- Name: idx_suppliers_supplier_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_suppliers_supplier_code ON public.suppliers USING btree (supplier_code);


--
-- Name: idx_suppliers_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_suppliers_type_id ON public.suppliers USING btree (type_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_is_admin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_is_admin ON public.users USING btree (is_admin);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_11_08_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_11_08_inserted_at_topic_idx ON realtime.messages_2025_11_08 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_11_09_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_11_09_inserted_at_topic_idx ON realtime.messages_2025_11_09 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_11_10_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_11_10_inserted_at_topic_idx ON realtime.messages_2025_11_10 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_11_11_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_11_11_inserted_at_topic_idx ON realtime.messages_2025_11_11 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2025_11_12_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2025_11_12_inserted_at_topic_idx ON realtime.messages_2025_11_12 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (bucket_id, name);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2025_11_08_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_11_08_inserted_at_topic_idx;


--
-- Name: messages_2025_11_08_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_11_08_pkey;


--
-- Name: messages_2025_11_09_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_11_09_inserted_at_topic_idx;


--
-- Name: messages_2025_11_09_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_11_09_pkey;


--
-- Name: messages_2025_11_10_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_11_10_inserted_at_topic_idx;


--
-- Name: messages_2025_11_10_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_11_10_pkey;


--
-- Name: messages_2025_11_11_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_11_11_inserted_at_topic_idx;


--
-- Name: messages_2025_11_11_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_11_11_pkey;


--
-- Name: messages_2025_11_12_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2025_11_12_inserted_at_topic_idx;


--
-- Name: messages_2025_11_12_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_11_12_pkey;


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: material_master set_material_master_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_material_master_updated_at BEFORE UPDATE ON public.material_master FOR EACH ROW EXECUTE FUNCTION public.update_master_updated_at();


--
-- Name: product_master set_product_master_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_product_master_updated_at BEFORE UPDATE ON public.product_master FOR EACH ROW EXECUTE FUNCTION public.update_master_updated_at();


--
-- Name: supplier_master set_supplier_master_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_supplier_master_updated_at BEFORE UPDATE ON public.supplier_master FOR EACH ROW EXECUTE FUNCTION public.update_master_updated_at();


--
-- Name: enums trigger_update_enums_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_enums_updated_at BEFORE UPDATE ON public.enums FOR EACH ROW EXECUTE FUNCTION public.update_enums_updated_at();


--
-- Name: attribute_definitions update_attribute_definitions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_attribute_definitions_updated_at BEFORE UPDATE ON public.attribute_definitions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: bom_items update_bom_items_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_bom_items_updated_at BEFORE UPDATE ON public.bom_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: colors update_colors_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_colors_updated_at BEFORE UPDATE ON public.colors FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: entity_type_nodes update_entity_type_nodes_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_entity_type_nodes_updated_at BEFORE UPDATE ON public.entity_type_nodes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: material_colors update_material_colors_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_material_colors_updated_at BEFORE UPDATE ON public.material_colors FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: material_suppliers update_material_suppliers_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_material_suppliers_updated_at BEFORE UPDATE ON public.material_suppliers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: materials update_materials_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_materials_updated_at BEFORE UPDATE ON public.materials FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_boms update_product_boms_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_product_boms_updated_at BEFORE UPDATE ON public.product_boms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: seasons update_seasons_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_seasons_updated_at BEFORE UPDATE ON public.seasons FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: suppliers update_suppliers_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: bom_items bom_items_bom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bom_items
    ADD CONSTRAINT bom_items_bom_id_fkey FOREIGN KEY (bom_id) REFERENCES public.product_boms(id) ON DELETE CASCADE;


--
-- Name: bom_items bom_items_color_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bom_items
    ADD CONSTRAINT bom_items_color_id_fkey FOREIGN KEY (color_id) REFERENCES public.colors(id) ON DELETE SET NULL;


--
-- Name: bom_items bom_items_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bom_items
    ADD CONSTRAINT bom_items_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE RESTRICT;


--
-- Name: bom_items bom_items_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bom_items
    ADD CONSTRAINT bom_items_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE SET NULL;


--
-- Name: colors colors_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colors
    ADD CONSTRAINT colors_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.entity_type_nodes(id) ON DELETE RESTRICT;


--
-- Name: entity_type_nodes entity_type_nodes_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_type_nodes
    ADD CONSTRAINT entity_type_nodes_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.entity_type_nodes(id) ON DELETE CASCADE;


--
-- Name: materials fk_materials_master; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT fk_materials_master FOREIGN KEY (material_code) REFERENCES public.material_master(material_code) ON DELETE CASCADE;


--
-- Name: products fk_products_master; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_master FOREIGN KEY (style_code) REFERENCES public.product_master(style_code) ON DELETE CASCADE;


--
-- Name: suppliers fk_suppliers_master; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT fk_suppliers_master FOREIGN KEY (supplier_code) REFERENCES public.supplier_master(supplier_code) ON DELETE CASCADE;


--
-- Name: material_colors material_colors_color_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_colors
    ADD CONSTRAINT material_colors_color_id_fkey FOREIGN KEY (color_id) REFERENCES public.colors(id) ON DELETE CASCADE;


--
-- Name: material_colors material_colors_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_colors
    ADD CONSTRAINT material_colors_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE CASCADE;


--
-- Name: material_suppliers material_suppliers_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_suppliers
    ADD CONSTRAINT material_suppliers_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE CASCADE;


--
-- Name: material_suppliers material_suppliers_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_suppliers
    ADD CONSTRAINT material_suppliers_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: materials materials_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.entity_type_nodes(id) ON DELETE RESTRICT;


--
-- Name: product_boms product_boms_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_boms
    ADD CONSTRAINT product_boms_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: products products_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- Name: products products_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.entity_type_nodes(id) ON DELETE RESTRICT;


--
-- Name: seasons seasons_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.entity_type_nodes(id) ON DELETE RESTRICT;


--
-- Name: suppliers suppliers_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.entity_type_nodes(id) ON DELETE RESTRICT;


--
-- Name: users users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: iceberg_namespaces iceberg_namespaces_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: attribute_definitions Authenticated users can delete attribute_definitions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete attribute_definitions" ON public.attribute_definitions FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: bom_items Authenticated users can delete bom_items; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete bom_items" ON public.bom_items FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: colors Authenticated users can delete colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete colors" ON public.colors FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: entity_type_nodes Authenticated users can delete entity_type_nodes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete entity_type_nodes" ON public.entity_type_nodes FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: material_colors Authenticated users can delete material_colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete material_colors" ON public.material_colors FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: material_suppliers Authenticated users can delete material_suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete material_suppliers" ON public.material_suppliers FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: materials Authenticated users can delete materials; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete materials" ON public.materials FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: product_boms Authenticated users can delete product_boms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete product_boms" ON public.product_boms FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: products Authenticated users can delete products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete products" ON public.products FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: seasons Authenticated users can delete seasons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete seasons" ON public.seasons FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: suppliers Authenticated users can delete suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can delete suppliers" ON public.suppliers FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: attribute_definitions Authenticated users can insert attribute_definitions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert attribute_definitions" ON public.attribute_definitions FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: bom_items Authenticated users can insert bom_items; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert bom_items" ON public.bom_items FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: colors Authenticated users can insert colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert colors" ON public.colors FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: entity_type_nodes Authenticated users can insert entity_type_nodes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert entity_type_nodes" ON public.entity_type_nodes FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: material_colors Authenticated users can insert material_colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert material_colors" ON public.material_colors FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: material_suppliers Authenticated users can insert material_suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert material_suppliers" ON public.material_suppliers FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: materials Authenticated users can insert materials; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert materials" ON public.materials FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: product_boms Authenticated users can insert product_boms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert product_boms" ON public.product_boms FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: products Authenticated users can insert products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert products" ON public.products FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: seasons Authenticated users can insert seasons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert seasons" ON public.seasons FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: suppliers Authenticated users can insert suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert suppliers" ON public.suppliers FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: users Authenticated users can insert users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can insert users" ON public.users FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: attribute_definitions Authenticated users can update attribute_definitions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update attribute_definitions" ON public.attribute_definitions FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: bom_items Authenticated users can update bom_items; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update bom_items" ON public.bom_items FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: colors Authenticated users can update colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update colors" ON public.colors FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: entity_type_nodes Authenticated users can update entity_type_nodes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update entity_type_nodes" ON public.entity_type_nodes FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: material_colors Authenticated users can update material_colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update material_colors" ON public.material_colors FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: material_suppliers Authenticated users can update material_suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update material_suppliers" ON public.material_suppliers FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: materials Authenticated users can update materials; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update materials" ON public.materials FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: product_boms Authenticated users can update product_boms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update product_boms" ON public.product_boms FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: products Authenticated users can update products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update products" ON public.products FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: seasons Authenticated users can update seasons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update seasons" ON public.seasons FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: suppliers Authenticated users can update suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update suppliers" ON public.suppliers FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: users Authenticated users can update users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can update users" ON public.users FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: attribute_definitions Authenticated users can view attribute_definitions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view attribute_definitions" ON public.attribute_definitions FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: bom_items Authenticated users can view bom_items; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view bom_items" ON public.bom_items FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: colors Authenticated users can view colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view colors" ON public.colors FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: entity_type_nodes Authenticated users can view entity_type_nodes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view entity_type_nodes" ON public.entity_type_nodes FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: material_colors Authenticated users can view material_colors; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view material_colors" ON public.material_colors FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: material_suppliers Authenticated users can view material_suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view material_suppliers" ON public.material_suppliers FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: materials Authenticated users can view materials; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view materials" ON public.materials FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: product_boms Authenticated users can view product_boms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view product_boms" ON public.product_boms FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: products Authenticated users can view products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view products" ON public.products FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: seasons Authenticated users can view seasons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view seasons" ON public.seasons FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: suppliers Authenticated users can view suppliers; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view suppliers" ON public.suppliers FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: users Authenticated users can view users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can view users" ON public.users FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: material_master Enable insert for authenticated users on material_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users on material_master" ON public.material_master FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: product_master Enable insert for authenticated users on product_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users on product_master" ON public.product_master FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: supplier_master Enable insert for authenticated users on supplier_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users on supplier_master" ON public.supplier_master FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: material_master Enable read access for authenticated users on material_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for authenticated users on material_master" ON public.material_master FOR SELECT TO authenticated USING (true);


--
-- Name: product_master Enable read access for authenticated users on product_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for authenticated users on product_master" ON public.product_master FOR SELECT TO authenticated USING (true);


--
-- Name: supplier_master Enable read access for authenticated users on supplier_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for authenticated users on supplier_master" ON public.supplier_master FOR SELECT TO authenticated USING (true);


--
-- Name: material_master Enable update for authenticated users on material_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for authenticated users on material_master" ON public.material_master FOR UPDATE TO authenticated USING (true);


--
-- Name: product_master Enable update for authenticated users on product_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for authenticated users on product_master" ON public.product_master FOR UPDATE TO authenticated USING (true);


--
-- Name: supplier_master Enable update for authenticated users on supplier_master; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for authenticated users on supplier_master" ON public.supplier_master FOR UPDATE TO authenticated USING (true);


--
-- Name: attribute_definitions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.attribute_definitions ENABLE ROW LEVEL SECURITY;

--
-- Name: bom_items; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.bom_items ENABLE ROW LEVEL SECURITY;

--
-- Name: colors; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.colors ENABLE ROW LEVEL SECURITY;

--
-- Name: entity_type_nodes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.entity_type_nodes ENABLE ROW LEVEL SECURITY;

--
-- Name: enums; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.enums ENABLE ROW LEVEL SECURITY;

--
-- Name: material_colors; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.material_colors ENABLE ROW LEVEL SECURITY;

--
-- Name: material_master; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.material_master ENABLE ROW LEVEL SECURITY;

--
-- Name: material_suppliers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.material_suppliers ENABLE ROW LEVEL SECURITY;

--
-- Name: materials; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.materials ENABLE ROW LEVEL SECURITY;

--
-- Name: product_boms; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_boms ENABLE ROW LEVEL SECURITY;

--
-- Name: product_master; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_master ENABLE ROW LEVEL SECURITY;

--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: seasons; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.seasons ENABLE ROW LEVEL SECURITY;

--
-- Name: supplier_master; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.supplier_master ENABLE ROW LEVEL SECURITY;

--
-- Name: suppliers; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: enums 枚举表仅管理员可修改; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "枚举表仅管理员可修改" ON public.enums TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.is_admin = true)))));


--
-- Name: enums 枚举表所有用户可读; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "枚举表所有用户可读" ON public.enums FOR SELECT TO authenticated USING (true);


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION get_enum_values(p_enum_type character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_enum_values(p_enum_type character varying) TO anon;
GRANT ALL ON FUNCTION public.get_enum_values(p_enum_type character varying) TO authenticated;
GRANT ALL ON FUNCTION public.get_enum_values(p_enum_type character varying) TO service_role;


--
-- Name: FUNCTION get_latest_version_id(p_table_name text, p_code_field text, p_code_value text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_latest_version_id(p_table_name text, p_code_field text, p_code_value text) TO anon;
GRANT ALL ON FUNCTION public.get_latest_version_id(p_table_name text, p_code_field text, p_code_value text) TO authenticated;
GRANT ALL ON FUNCTION public.get_latest_version_id(p_table_name text, p_code_field text, p_code_value text) TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION update_enums_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_enums_updated_at() TO anon;
GRANT ALL ON FUNCTION public.update_enums_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.update_enums_updated_at() TO service_role;


--
-- Name: FUNCTION update_master_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_master_updated_at() TO anon;
GRANT ALL ON FUNCTION public.update_master_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.update_master_updated_at() TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;


--
-- Name: TABLE attribute_definitions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.attribute_definitions TO anon;
GRANT ALL ON TABLE public.attribute_definitions TO authenticated;
GRANT ALL ON TABLE public.attribute_definitions TO service_role;


--
-- Name: TABLE bom_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bom_items TO anon;
GRANT ALL ON TABLE public.bom_items TO authenticated;
GRANT ALL ON TABLE public.bom_items TO service_role;


--
-- Name: TABLE colors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.colors TO anon;
GRANT ALL ON TABLE public.colors TO authenticated;
GRANT ALL ON TABLE public.colors TO service_role;


--
-- Name: TABLE entity_type_nodes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.entity_type_nodes TO anon;
GRANT ALL ON TABLE public.entity_type_nodes TO authenticated;
GRANT ALL ON TABLE public.entity_type_nodes TO service_role;


--
-- Name: TABLE enums; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.enums TO anon;
GRANT ALL ON TABLE public.enums TO authenticated;
GRANT ALL ON TABLE public.enums TO service_role;


--
-- Name: TABLE material_colors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.material_colors TO anon;
GRANT ALL ON TABLE public.material_colors TO authenticated;
GRANT ALL ON TABLE public.material_colors TO service_role;


--
-- Name: TABLE material_master; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.material_master TO anon;
GRANT ALL ON TABLE public.material_master TO authenticated;
GRANT ALL ON TABLE public.material_master TO service_role;


--
-- Name: TABLE material_suppliers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.material_suppliers TO anon;
GRANT ALL ON TABLE public.material_suppliers TO authenticated;
GRANT ALL ON TABLE public.material_suppliers TO service_role;


--
-- Name: TABLE materials; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.materials TO anon;
GRANT ALL ON TABLE public.materials TO authenticated;
GRANT ALL ON TABLE public.materials TO service_role;


--
-- Name: TABLE materials_latest; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.materials_latest TO anon;
GRANT ALL ON TABLE public.materials_latest TO authenticated;
GRANT ALL ON TABLE public.materials_latest TO service_role;


--
-- Name: TABLE product_boms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_boms TO anon;
GRANT ALL ON TABLE public.product_boms TO authenticated;
GRANT ALL ON TABLE public.product_boms TO service_role;


--
-- Name: TABLE product_master; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_master TO anon;
GRANT ALL ON TABLE public.product_master TO authenticated;
GRANT ALL ON TABLE public.product_master TO service_role;


--
-- Name: TABLE products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.products TO anon;
GRANT ALL ON TABLE public.products TO authenticated;
GRANT ALL ON TABLE public.products TO service_role;


--
-- Name: TABLE products_latest; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.products_latest TO anon;
GRANT ALL ON TABLE public.products_latest TO authenticated;
GRANT ALL ON TABLE public.products_latest TO service_role;


--
-- Name: TABLE seasons; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.seasons TO anon;
GRANT ALL ON TABLE public.seasons TO authenticated;
GRANT ALL ON TABLE public.seasons TO service_role;


--
-- Name: TABLE supplier_master; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.supplier_master TO anon;
GRANT ALL ON TABLE public.supplier_master TO authenticated;
GRANT ALL ON TABLE public.supplier_master TO service_role;


--
-- Name: TABLE suppliers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.suppliers TO anon;
GRANT ALL ON TABLE public.suppliers TO authenticated;
GRANT ALL ON TABLE public.suppliers TO service_role;


--
-- Name: TABLE suppliers_latest; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.suppliers_latest TO anon;
GRANT ALL ON TABLE public.suppliers_latest TO authenticated;
GRANT ALL ON TABLE public.suppliers_latest TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2025_11_08; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_11_08 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_11_08 TO dashboard_user;


--
-- Name: TABLE messages_2025_11_09; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_11_09 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_11_09 TO dashboard_user;


--
-- Name: TABLE messages_2025_11_10; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_11_10 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_11_10 TO dashboard_user;


--
-- Name: TABLE messages_2025_11_11; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_11_11 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_11_11 TO dashboard_user;


--
-- Name: TABLE messages_2025_11_12; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2025_11_12 TO postgres;
GRANT ALL ON TABLE realtime.messages_2025_11_12 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE iceberg_namespaces; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_namespaces TO service_role;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_namespaces TO anon;


--
-- Name: TABLE iceberg_tables; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.iceberg_tables TO service_role;
GRANT SELECT ON TABLE storage.iceberg_tables TO authenticated;
GRANT SELECT ON TABLE storage.iceberg_tables TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE prefixes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.prefixes TO service_role;
GRANT ALL ON TABLE storage.prefixes TO authenticated;
GRANT ALL ON TABLE storage.prefixes TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict YISZ8HdWwnvgTabzXaS7yGEIFVfqEFKen1pUB0vfTBq9ELK75xZJ1jgerTtRg4O

