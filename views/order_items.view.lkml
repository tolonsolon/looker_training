view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  measure: total_price {
    type: sum
    sql: ${sale_price} ;;
    label: "総売上"
  }

  measure: average_price {
    type: average
    sql: ${sale_price} ;;
    label: "平均売上"
  }



  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    label: "Eメール総売り上げ"
    filters: [users.is_email_source: "Yes"]
#     filters: {
#       field: users.is_email_source
#       value: "Yes"
#     }
  }


  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_sales_email_users}/NULLIF(${total_price}, 0) ;;
  }



  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_price} / NULLIF(${users.count},0) ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id};;
    label: "オーダー数"
    description: "ユニークなオーダー数"

  }


  dimension: Shipping_Days{
    type: number
    sql:DATEDIFF(day,${shipped_date},${delivered_date}  ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.id,
      inventory_items.id,
      inventory_items.product_name
    ]
  }

}
