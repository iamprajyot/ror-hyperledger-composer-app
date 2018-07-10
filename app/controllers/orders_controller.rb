class OrdersController < ApplicationController
  def index
    order_service = OrderService.new(access_token)
    begin
      orders = convert_to_hash(order_service.fetchOrders)
      if it_admin?
        order_transactions = convert_to_hash_for_issue(order_service.fetchOrderIssuedTransactions)
      else
        order_transactions = convert_to_hash(order_service.fetchOrderTransactions)
      end
    rescue
      flash
    end
    @orders = orders.merge(order_transactions) {|k, o, n| o.merge(n)}
    @orders
  end

  def new
  end

  def place
    orderParams = order_params
    orderParams.merge!({
          "$class": "org.synerzip.firstcomposer.PlaceOrder",
          "orderId": generate_random_id,
          "orderer": participant_id
        })
    order_service = OrderService.new(access_token)
    res = order_service.placeOrder(orderParams)
    redirect_to orders_path
  end

  private

  def order_params
    params.permit(:productType)
  end

  def convert_to_hash(h)
    result = {}
    h.each do |o|
      result[o['orderId']] = o
    end
    result
  end

  def convert_to_hash_for_issue(h)
    result = {}
    h.each do |o|
      result[extract_resource_id(o['order'])] = o
    end
    result
  end
end
