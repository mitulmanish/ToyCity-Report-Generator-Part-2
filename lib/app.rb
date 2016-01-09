require 'json'

def brand
  "       BRANDS"
end

def product
  "       PRODUCTS"
end
def sales_report
  "       SALES REPORT"
end

def file_setup
  $products_hash = {}
  $report_file = nil
  $brands = []
end

def setup
  file_setup
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $brands = find_brand
  $report_file = File.new("report.txt", "w+")
  padding
end

def print_product_report
  print_header product
  padding
  products_report
  padding
end

def print_sales_report
  print_header sales_report
  padding
  product_sales_report
  padding
end

def print_brands_report
  padding
  brands_report
end

def start
  setup
  write_file "DATE",Time.now.strftime("%m/%d/%Y")
  print_product_report
  print_sales_report
  print_header brand
  print_brands_report
end

def product_selling_price (purchases)
  selling_price = []
  purchases.each do |purchase|
    selling_price << purchase["price"]
  end
  selling_price
end

def separator
  $report_file.puts("*"*20)
end

def padding
  $report_file.write(""+"\n")
end

def total_price(prices)
  prices.inject(:+)
end

def total_revenue(revenues)
  revenues.inject(:+)
end

def get_revenue (items,brand)
  revenues = []
  items.each do |item|
    item["purchases"].each {|purchase| revenues << (purchase["price"]).to_f} if brand?(brand, item)
  end
  revenues
end

def get_quantity (items,brand)
  stock = 0
  items.each do |item|
    stock += item["stock"] if brand?(brand, item)
  end
  stock
end

def brand?(brand, item)
  item["brand"] == brand
end

def get_price (items,brand)
  prices = []
  items.each do |item|
    prices << item["full-price"].to_f.round(2) if brand?(brand, item)
  end
  prices
end

def find_brand
  brands = []
  $products_hash["items"].each do |item|
    brands << item["brand"]
  end
  brands.uniq!
end

def discount_percentage (average_discount,full_price)
  ((average_discount/full_price)*100).round(2)
end
def write_file (message,data)
  $report_file.write(message+" : "+data.to_s+ "\n")
end

def print_header(data)
  $report_file.write(data.to_s)
end

def grand_selling_price(selling_price)
  selling_price.inject(:+)
end

def product_sales_report()
  padding
  $products_hash["items"].each do |item|
    write_file "Total Purchases for #{item["title"]}", item["purchases"].size
    selling_price = product_selling_price(item["purchases"])
    write_file "Total Amount of Sales for #{item["title"]}", grand_selling_price(product_selling_price(item["purchases"]))
    write_file "Average Selling Price", (grand_selling_price(selling_price)/selling_price.size)
    write_file "Average Discounted Percentage:", discount_percentage(item["full-price"].to_f-((grand_selling_price(selling_price)/selling_price.size)), item["full-price"].to_f).to_s + " %"
    separator
  end
end

def products_report
  padding
  $products_hash["items"].each do |item|
    write_file "Title",item["title"]
    write_file "Full Price",item["full-price"]
    write_file "Brand",item["brand"]
    separator
  end
end

def brand_sales_report(brand, prices, revenues, stock)
  write_file "Stock for #{brand}", stock
  total_price = total_price(prices)
  write_file "Average price for #{brand}", (total_price/prices.size).round(2)
  total_revenue = total_revenue(revenues)
  write_file "Total revenue for #{brand}", total_revenue.round(2)
end

def brands_report
  padding
  $brands.each do |brand|
    write_file "Brand",brand
    revenues = get_revenue($products_hash["items"], brand)
    stock = get_quantity($products_hash["items"], brand)
    prices = get_price($products_hash["items"], brand)
    brand_sales_report(brand, prices, revenues, stock)
    separator
  end
end

start
