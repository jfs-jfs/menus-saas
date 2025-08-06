import domain/payment/value_object/business_name.{type BusinessName}
import domain/payment/value_object/invoice_information.{type InvoiceInformation}
import domain/payment/value_object/owner_id.{type OwnerId}
import domain/payment/value_object/restaurant_id.{type RestaurantId}
import gleam/option.{type Option}

pub type Restaurant {
  Restaurant(
    id: Option(RestaurantId),
    owner_id: OwnerId,
    name: BusinessName,
    wants_invoice: InvoiceInformation,
  )
}
