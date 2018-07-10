class ProductsController < ApplicationController
  def index
    product = ProductService.new(access_token)
    @products = product.all
  end

  def new
  end

  def create
    productParams = product_params
    productParams.merge!({
          "$class": "org.synerzip.firstcomposer.Product",
          "productId": generate_random_id,
          "status": AVAILABLE
        })
    product = ProductService.new(access_token)
    begin
      res = product.create(productParams)
      if res['error'].nil?
        flash[:success] = 'Product has been added successfuly'
        redirect_to products_path
      else
        flash[:error] = 'Error while adding new product'
        redirect_to products_new_path
      end
    rescue
      flash[:error] = 'Exception while adding new product'
      redirect_to products_new_path
    end
  end

  def edit
  end

  def show
  end

  def issue
    issue_params = {
      "$class": "org.synerzip.firstcomposer.IssueProductAndUpdateOrderStatus",
      "order": params[:order][:$class]+'#'+params[:order][:orderId],
      "issuer": participant_id
    }
    product = ProductService.new(access_token)
    begin
      res = product.issue(issue_params)
      if res['error'].nil?
        flash[:success] = 'Product has been issued successfuly'
      else
        flash[:error] = 'Error while issueing product'
      end
    rescue
      flash[:error] = 'Exception while issueing product'
    end
    redirect_to orders_path
  end

  private

  def product_params
    params.permit(:productType)
  end
end
