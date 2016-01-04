require 'json'
PRODUCT = "                     _            _       " +"\n"+
    "                    | |          | |      " +"\n"+
    " _ __  _ __ ___   __| |_   _  ___| |_ ___ " +"\n"+
    "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|" +"\n"+
    "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\" +"\n"+
    "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/" +"\n"+
    "| |                                       "+"\n"+
    "|_|                                       " +"\n"

BRAND = " _                         _     "+"\n"+
"| |                       | |    "+"\n"+
"| |__  _ __ __ _ _ __   __| |___ "+"\n"+
"| '_ \\| '__/ _` | '_ \\ / _` / __|"+"\n"+
"| |_) | | | (_| | | | | (_| \\__ \\"+"\n"+
"|_.__/|_|  \\__,_|_| |_|  \\__,_|___/"+"\n"


$products_hash = {}
$report_file = nil
$brands = []

def setup
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $brands = find_brand
  $report_file = File.new("report.txt", "w+")
  padding
end


def start
  setup
  write_file "DATE",Time.now.strftime("%m/%d/%Y")
  print_header PRODUCT
  padding
  products_report
  padding
  print_header BRAND
  padding
  brands_report
end

def product_selling_price (purchases)
  selling_price = []
  purchases.each do |purchase|
    selling_price << purchase["price"]
  end
  selling_price
end

def separator
  $report_file.write("---------------------------------------"+"\n")
end

def padding
  $report_file.write(""+"\n")
end


def total_price(prices)
  total_price = 0
  prices.each { |price| total_price += price }
  total_price
end

def total_revenue(revenues)
  total_revenue = 0
  revenues.each { |revenue| total_revenue += revenue }
  total_revenue
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
=begin
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
  total_selling_price = 0
  selling_price.each { |price| total_selling_price+=price }
  total_selling_price
end

def product_sales_report(item)
  write_file "Total Purchases", item["purchases"].size
  selling_price = product_selling_price(item["purchases"])
  write_file "Total Amount of Sales for #{item["title"]}", grand_selling_price(product_selling_price(item["purchases"]))
  write_file "Average Selling Price", (grand_selling_price(selling_price)/selling_price.size)
  write_file "Average Discounted Percentage:", discount_percentage(item["full-price"].to_f-((grand_selling_price(selling_price)/selling_price.size)), item["full-price"].to_f).to_s + " %"
  separator
end

def products_report
  $products_hash["items"].each do |item|
    write_file "Title",item["title"]
    write_file "Full Price",item["full-price"]
    write_file "Brand",item["brand"]
    product_sales_report(item)
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
  $brands.each do |brand|
    write_file "Brand",brand
    revenues = get_revenue($products_hash["items"], brand)
    stock = get_quantity($products_hash["items"], brand)
    prices = get_price($products_hash["items"], brand)
    brand_sales_report(brand, prices, revenues, stock)
    separator
  end
end







# For each product in the data set:
# Print the name of the toy
# Print the retail price of the toy
# Print the name of the brand
# Calculate and print the total number of purchases
# Calculate and print the total amount of sales
# Calculate and print the average price the toy sold for
# Calculate and print the average discount based off the average sales price
start







# For each brand in the data set:
# Print the name of the brand
# Count and print the number of the brand's toys we stock
# Calculate and print the average price of the brand's toys
# Calculate and print the total revenue of all the brand's toy sales combined














# Print "Sales Report" in ascii art

# Print today's date

# Print "Products" in ascii art

# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount based off the average sales price

# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
