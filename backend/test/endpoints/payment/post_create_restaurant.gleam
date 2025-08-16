import adapters/http/common/http_codes
import glacier/should
import tools/database_setup
import tools/db_utils
import tools/e2e_utils
import tools/shouldx

const target = "/v1/restaurant"

pub fn create_restaurant_ok_full_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)

  should.equal(response.status, http_codes.no_content)
  should.equal(e2e_utils.extract_body(response), "[]")
}

pub fn create_restaurant_ok_partial_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)

  should.equal(response.status, http_codes.no_content)
  should.equal(e2e_utils.extract_body(response), "[]")
}

pub fn create_restaurant_ko_invalid_invoice_number_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_invalid_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("invalid building number")
}

pub fn create_restaurant_ko_missing_invoice_bumber_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("address_building_number")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_invoice_street_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_invalid_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("invalid street")
}

pub fn create_restaurant_ko_missing_invoice_street_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("address_street")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_invoice_city_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_invalid_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("unknown city")
}

pub fn create_restaurant_ko_missing_invoice_city_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("address_city")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_invoice_postal_code_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_invalid_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("invalid postal code")
}

pub fn create_restaurant_ko_missing_invoice_postal_code_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("address_postal_code")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_invoice_province_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_invalid_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("invalid province")
}

pub fn create_restaurant_ko_missing_invoice_province_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("address_province")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_recipient_email_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_invalid_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("invalid email format")
}

pub fn create_restaurant_ko_missing_recipient_email_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("recipient_email")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_recipient_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_invalid_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("invalid recipient name")
}

pub fn create_restaurant_ko_missing_recipient_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("recipient")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_nif_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_invalid_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("invalid nif format")
}

pub fn create_restaurant_ko_missing_nif_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invoice")
  body |> shouldx.contain("nif")
  body |> shouldx.contain("invalid nif format")
}

pub fn create_restaurant_ko_invalid_street_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_invalid_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invalid street format")
}

pub fn create_restaurant_ko_missing_street_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("address_street")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_city_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_invalid_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("unknown city")
}

pub fn create_restaurant_ko_missing_city_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("address_city")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_province_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_invalid_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("invalid province")
}

pub fn create_restaurant_ko_missing_province_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("address_province")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_phone_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_invalid_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("phone")
  body |> shouldx.contain("invalid phone number")
}

pub fn create_restaurant_ko_missing_phone_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("phone")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_invalid_name_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_invalid_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("name")
  body |> shouldx.contain("invalid business name format")
}

pub fn create_restaurant_ko_missing_name_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_authenticated_json(target, [], request)
  should.equal(response.status, http_codes.bad_request)

  let body = e2e_utils.extract_body(response)
  body |> shouldx.contain("name")
  body |> shouldx.contain("field was expected but found nothing")
}

pub fn create_restaurant_ko_unauthenticated_partial_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": null
      }
    "
  use response <- e2e_utils.post_json(target, [], request)

  should.equal(response.status, http_codes.unauthorized)
  should.equal(e2e_utils.extract_body(response), "[]")
}

pub fn create_restaurant_ko_unauthenticated_full_test() {
  use <- database_setup.with_clean_db()

  let request = "
      {
        \"name\": \"" <> db_utils.get_restaurant_name() <> "\",
        \"phone\": \"" <> db_utils.get_phone() <> "\",
        \"address_province\": \"" <> db_utils.get_province() <> "\",
        \"address_city\": \"" <> db_utils.get_city() <> "\",
        \"address_street\": \"" <> db_utils.get_street() <> "\",
        \"invoice\": {
          \"nif\": \"" <> db_utils.get_nif() <> "\",
          \"recipient\": \"" <> db_utils.get_name() <> "\",
          \"recipient_email\": \"" <> db_utils.get_email() <> "\",
          \"address_province\": \"" <> db_utils.get_province() <> "\",
          \"address_postal_code\": \"" <> db_utils.get_postal_code() <> "\",
          \"address_city\": \"" <> db_utils.get_city() <> "\",
          \"address_street\": \"" <> db_utils.get_street() <> "\",
          \"address_building_number\": \"" <> db_utils.get_building_number() <> "\"
        }
      }
    "
  use response <- e2e_utils.post_json(target, [], request)

  should.equal(response.status, http_codes.unauthorized)
  should.equal(e2e_utils.extract_body(response), "[]")
}
