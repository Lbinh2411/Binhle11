SELECT* from [Purchasing].[PurchaseOrderDetail]
SELECT*from [Purchasing].[PurchaseOrderHeader];
---1.1 Sử dụng dữ liệu từ bảng Purchasing.PurchaseOrderDetail xuất dữ liệu số lượng sản phẩm bị từ chối nhận hàng(bao gồm thông tin orderid, ngày đặt hàng, số lượng sản phẩm order, id sản phẩm, giá sản phẩm, ngày cập nhật thông tin) để quản lý kinh doanh nắm được thông tin.
Select  
    PurchaseOrderID, Duedate, OrderQty, ProductID, UnitPrice, RejectedQty, ModifiedDate
from 
    [Purchasing].[PurchaseOrderDetail]
where 
    RejectedQty > 0;

---1.2 Kết hợp dữ liệu từ bảng Purchasing.PurchaseOrderDetail và bảng Purchasing.PurchaseOrderHeader để xuất ra dữ liệu bao gồm: tổng số lượng đơn hàng, tổng số sản phẩm giao thành công, tổng giá trị mua theo ID nhân viên, sau đó sắp xếp theo thứ tự giảm dần theo tổng giá trị mua(1đ). Tạo cột ranking thể hiện rank id nhân viên theo tổng giá trị mua giảm dần(tổng giá trị mua cao nhất rank là 1, cao thứ 2 rank là 2…)
with bangtam as(
    select
        poh.PurchaseOrderID, poh.EmployeeID, pod.ReceivedQty, pod.LineTotal
    from 
        [Purchasing].[PurchaseOrderHeader] poh
        left join
            [Purchasing].[PurchaseOrderDetail] pod
        on poh.PurchaseOrderID = pod.PurchaseOrderID

)
SELECT
   count(purchaseorderID) as numberorder, EmployeeID, sum(ReceivedQty) as totalQty, sum(LineTotal) as Revenue, Rank () over (order by sum(linetotal) desc) as ranking
FROM
    bangtam
group by EmployeeID
Order by Revenue desc;

--- 1.3 Dựa vào bảng HumanResources.EmployeeDepartmentHistory xuất ra danh sách những nhân viên từng chuyển bộ phận hoặc nghỉ việc.

select 
    *
from [HumanResources].[EmployeeDepartmentHistory]
WHERE
    ShiftID > 1 
	or EndDate is not null