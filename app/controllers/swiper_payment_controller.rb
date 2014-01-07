require 'authorize_net'
AuthorizeNet::Reporting::Fields.class_eval do
  GET_UNSETTLED_TRANSACTION_LIST = []
end
AuthorizeNet::Reporting::Transaction.class_eval do
  def get_unsettled_transaction_list
    if has_response?
      return nil
    end
    
    @type = "getUnsettledTransactionListRequest"
    fields = @fields
    
    builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |x|
      x.send(@type.to_sym, :xmlns => 'AnetApi/xml/v1/schema/AnetApiSchema.xsd') {
        x.merchantAuthentication {
          x.name @api_login_id
          x.transactionKey @api_transaction_key
        }
        #build_nodes(x, self.class.const_get(:FIELDS)[@type], fields)
      }
    end
    @xml = builder.to_xml
    
    url = URI.parse(@gateway)
    
    request = Net::HTTP::Post.new(url.path)
    request.content_type = 'text/xml'
    request.body = @xml
    connection = Net::HTTP.new(url.host, url.port)
    connection.use_ssl = true
    if @verify_ssl
      connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
    else
      connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    # Use our Class's @response_class variable to find the Response class we are supposed to use.
    begin
      @response = self.class.instance_variable_get(:@response_class).new((connection.start {|http| http.request(request)}), self)
    rescue
      @response = self.class.instance_variable_get(:@response_class).new($!, self)
    end
  end
end

module Spree
class SwiperPaymentController < Spree::StoreController
  def paid
    payment_method_id = Spree::PaymentMethod.where(:type => 'Spree::PaymentMethod::Swiper').first.id
    order = current_order
    translist = a=AuthorizeNet::Reporting::Transaction.new(AUTHORIZE_NET_API_ID,AUTHORIZE_NET_API_KEY).get_unsettled_transaction_list
    if translist.transactions.count > 0
      translist.transactions.each do |t|
        if t.order.invoice_num.to_i == order.id and t.settle_amount.to_f == (order.total.to_f*100).round/100.0
          # create payment
          payment = order.payments.new(:amount => t.settle_amount, :payment_method_id => payment_method_id)
          payment.state = :completed
          payment.save
          # finalize order
          order.finalize!
          order.state = :complete
          order.save
          redirect_to account_url
          return
        end
      end
    end
    redirect_to "/checkout/payment", :alert => "Could not confirm payment"
  end
end
end