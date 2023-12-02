import pandas as pd

def main():
    # prior to computation: write a query which sorts rows by oldest --> newest transaction date
    # save this updated table and use it here
    TRANSACTIONS_FILE = "transactionsT_sorted.xlsx"
    data_frame = pd.read_excel(TRANSACTIONS_FILE)
    print("Done reading data frame")
    viable_customers, receipts = get_viable_customers(data_frame) # works
    print(viable_customers)
    #print(receipts)
    # for each customer, write to respective files
    for i, customer in enumerate(viable_customers):
        get_first_basket(receipts[i][0], customer, data_frame, "firstBasket.txt") # first basket
        get_first_basket(receipts[i][1], customer, data_frame, "secondBasket.txt") # second basket
    
def get_viable_customers(data_frame):
    '''
    return a list of all customers who have >= 2 checkouts
    return a list of the first two receipts of the customer
    '''
    # RETURNS
    customers = []
    receipts = []
    
    num_rows = len(data_frame)
    seen_ids = []
    seen_dict = dict()
    # count unique TILL_RECEIPT_NUMBER for each customer
    for i in range(num_rows):
        current_row = list(data_frame.iloc[i])
        current_customer_id = current_row[1]
        #current_receipts = []
        if current_customer_id not in seen_ids:
            seen_ids.append(current_customer_id)
            seen_dict[current_customer_id] = current_row[7] # store the receipt
        elif current_customer_id in seen_ids and current_row[7] != seen_dict[current_customer_id] and current_customer_id not in customers:
            print(current_customer_id)
            customers.append(current_customer_id)
            receipts.append([seen_dict[current_customer_id], current_row[7]])
    return customers, receipts
   

def get_first_basket(first_receipt_number, current_id, data_frame, file_flag):
    # current_id = id to search
    # first_receipt_number = reciept to search
    '''
    get the contents of the first basket for each viable customer
    and ...
    
    Basket # 1 for {customer_id}:
    =====================================================================
    TILL_RECEIPT_NUMBER: {}
    TRANSACTION_DATE: {}
    {item_desc} | {quantity} | {sales_value} | {cost} | {sub_department}
    =====================================================================
    '''
    items_in_basket = []
    quantity = []
    sales_value = []
    cost = []
    sub_departments = []
    transaction_date = "ERR"
    
    # this function can just be appropriated for the second_basket aswell by passing a different receipt number into it
    # essentially William you'll call this function for all Id's in viable_customers, passing in each receipt number
    num_rows = len(data_frame)
    for i in range(num_rows):
        current_row = list(data_frame.iloc[i])
        current_receipt = current_row[7]
        row_id = current_row[1]
        if current_receipt == first_receipt_number and current_id == row_id:
            # note: How do i want to format my data: see above?
            transaction_date = current_row[9]
            items_in_basket.append(current_row[3])
            quantity.append(current_row[10])
            sales_value.append(current_row[11])
            cost.append(current_row[12])
            sub_departments.append(current_row[5])
    
    # now, write to txt documents
    if file_flag == "firstBasket.txt":
        f = 1
    else:
        f = 2
    
    # currently overwriting  - why
    # also not showing data when it clearly exists
    with open(str(file_flag), 'a') as file:
        file.write(f"Basket # {f} for {current_id}:\n")
        file.write(f"========================================================\n")
        file.write(f"TILL_RECEIPT_NUMBER: {first_receipt_number}\n")
        file.write(f"TRANSACTION_DATE: {transaction_date}\n")
        for i in range(len(items_in_basket)):
            file.write(f"{items_in_basket[i]} | {quantity[i]} | {sales_value[i]} | {cost[i]} | {sub_departments[i]} | \n")
        file.write(f"========================================================\n")
        file.close()
    print(f"Entry added in {f}")
main()