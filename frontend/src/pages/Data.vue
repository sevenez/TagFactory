<template>
  <div class="card">
    <div class="title">数据管理</div>
    
    <!-- 数据展示区域 -->
    <div class="data-section">
      <div class="title" style="margin-top:24px">数据概览</div>
      <div class="data-overview">
        <div class="overview-card">
          <div class="count">{{ customerCount || '--' }}</div>
          <div class="label">客户总数</div>
        </div>
        <div class="overview-card">
          <div class="count">{{ merchantCount || '--' }}</div>
          <div class="label">商家总数</div>
        </div>
        <div class="overview-card">
          <div class="count">{{ productCount || '--' }}</div>
          <div class="label">商品总数</div>
        </div>
      </div>
    </div>
    
    <!-- 数据标签页 -->
    <div class="data-tabs" style="margin-top:24px">
      <div class="tab-buttons">
        <button 
          v-for="tab in tabs" 
          :key="tab.key" 
          :class="['tab-button', { active: activeTab === tab.key }]"
          @click="switchTab(tab.key)"
        >
          {{ tab.name }}
        </button>
      </div>
      
      <!-- 客户数据标签页 -->
      <div v-if="activeTab === 'customers'" class="tab-content">
        <div class="filter-section">
          <input 
            v-model="customerFilters.name" 
            type="text" 
            placeholder="搜索客户名称..." 
            class="filter-input"
          />
          <select v-model="customerFilters.status" class="filter-select">
            <option value="">全部状态</option>
            <option value="active">活跃</option>
            <option value="inactive">非活跃</option>
          </select>
          <select v-model="customerFilters.sort" class="filter-select">
            <option value="created_at:desc">最新创建</option>
            <option value="created_at:asc">最早创建</option>
            <option value="name:asc">名称升序</option>
            <option value="name:desc">名称降序</option>
          </select>
        </div>
        
        <div class="table-container">
            <table class="data-table">
              <thead>
                <tr>
                  <th>客户ID</th>
                  <th>手机号</th>
                  <th>性别</th>
                  <th>年龄</th>
                  <th>学历</th>
                  <th>所在省份</th>
                  <th>注册时间</th>
                  <th>最近活跃时间</th>
                  <th>已消费金额</th>
                  <th>消费月数</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="customer in customers" :key="customer.customer_id" class="table-row">
                  <td :title="customer.customer_id">{{ truncateText(customer.customer_id, 12) }}</td>
                  <td :title="customer.phone">{{ truncateText(customer.phone, 15) }}</td>
                  <td>{{ customer.gender || '未知' }}</td>
                  <td>{{ customer.age || 0 }}</td>
                  <td>{{ customer.education || '其他' }}</td>
                  <td>{{ customer.province || '-' }}</td>
                  <td :title="formatTime(customer.register_time)">{{ formatTime(customer.register_time) }}</td>
                  <td :title="formatTime(customer.last_active_time)">{{ formatTime(customer.last_active_time) }}</td>
                  <td>¥{{ (Number(customer.total_consume) || 0).toFixed(2) }}</td>
                  <td>{{ customer.consume_months || 0 }}个月</td>
                </tr>
              </tbody>
            </table>
          </div>
        
        <div class="pagination" v-if="customerTotal > 0">
          <span class="page-info">显示 {{ customers.length > 0 ? ((customerPage - 1) * pageSize + 1) : 0 }}-{{ Math.min(customerPage * pageSize, customerTotal) }} 条，共 {{ customerTotal }} 条</span>
          <div class="page-buttons">
            <button @click="changeCustomerPage(customerPage - 1)" :disabled="customerPage === 1">上一页</button>
            <button @click="changeCustomerPage(customerPage + 1)" :disabled="customerPage >= Math.ceil(customerTotal / pageSize)">下一页</button>
          </div>
        </div>
        <div v-else class="empty-state">暂无客户数据</div>
      </div>
      
      <!-- 商家数据标签页 -->
      <div v-if="activeTab === 'merchants'" class="tab-content">
        <div class="filter-section">
          <input 
            v-model="merchantFilters.name" 
            type="text" 
            placeholder="搜索商家名称..." 
            class="filter-input"
          />
          <select v-model="merchantFilters.category" class="filter-select">
            <option value="">全部类别</option>
            <option value="electronics">电子产品</option>
            <option value="clothing">服装</option>
            <option value="food">食品</option>
            <option value="other">其他</option>
          </select>
          <select v-model="merchantFilters.sort" class="filter-select">
            <option value="created_at:desc">最新创建</option>
            <option value="created_at:asc">最早创建</option>
            <option value="name:asc">名称升序</option>
            <option value="name:desc">名称降序</option>
          </select>
        </div>
        
        <div class="table-container">
          <table class="data-table">
            <thead>
                <tr>
                  <th>商家ID</th>
                  <th>商家名称</th>
                  <th>商家类型</th>
                  <th>信用代码</th>
                  <th>联系电话</th>
                  <th>联系邮箱</th>
                  <th>经营地址</th>
                  <th>评分</th>
                  <th>入驻时间</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="merchant in merchants" :key="merchant.seller_id" class="table-row">
                  <td :title="merchant.seller_id">{{ truncateText(merchant.seller_id, 12) }}</td>
                  <td :title="merchant.seller_name">{{ truncateText(merchant.seller_name, 20) }}</td>
                  <td>{{ merchant.seller_type || '-' }}</td>
                  <td :title="merchant.credit_code">{{ truncateText(merchant.credit_code, 18) }}</td>
                  <td>{{ merchant.contact_phone || '-' }}</td>
                  <td :title="merchant.contact_email">{{ truncateText(merchant.contact_email || '-', 20) }}</td>
                  <td :title="merchant.business_address">{{ truncateText(merchant.business_address || '-', 30) }}</td>
                  <td>{{ merchant.seller_rating || 0 }}</td>
                  <td :title="formatTime(merchant.create_time)">{{ formatTime(merchant.create_time) }}</td>
                </tr>
              </tbody>
          </table>
        </div>
        
        <div class="pagination" v-if="merchantTotal > 0">
          <span class="page-info">显示 {{ merchants.length > 0 ? ((merchantPage - 1) * pageSize + 1) : 0 }}-{{ Math.min(merchantPage * pageSize, merchantTotal) }} 条，共 {{ merchantTotal }} 条</span>
          <div class="page-buttons">
            <button @click="changeMerchantPage(merchantPage - 1)" :disabled="merchantPage === 1">上一页</button>
            <button @click="changeMerchantPage(merchantPage + 1)" :disabled="merchantPage >= Math.ceil(merchantTotal / pageSize)">下一页</button>
          </div>
        </div>
        <div v-else class="empty-state">暂无商家数据</div>
      </div>
      
      <!-- 商品数据标签页 -->
      <div v-if="activeTab === 'products'" class="tab-content">
        <div class="filter-section">
          <input 
            v-model="productFilters.name" 
            type="text" 
            placeholder="搜索商品名称..." 
            class="filter-input"
          />
          <select v-model="productFilters.merchant_id" class="filter-select">
            <option value="">全部商家</option>
            <option v-for="merchant in allMerchants" :key="merchant.seller_id" :value="merchant.seller_id">
              {{ merchant.seller_name }}
            </option>
          </select>
          <select v-model="productFilters.category" class="filter-select">
            <option value="">全部类别</option>
            <option value="electronics">电子产品</option>
            <option value="clothing">服装</option>
            <option value="food">食品</option>
            <option value="other">其他</option>
          </select>
          <select v-model="productFilters.sort" class="filter-select">
            <option value="created_at:desc">最新创建</option>
            <option value="created_at:asc">最早创建</option>
            <option value="name:asc">名称升序</option>
            <option value="name:desc">名称降序</option>
            <option value="price:asc">价格升序</option>
            <option value="price:desc">价格降序</option>
          </select>
        </div>
        
        <div class="table-container">
            <table class="data-table">
              <thead>
                <tr>
                  <th>商品ID</th>
                  <th>商品名称</th>
                  <th>品牌</th>
                  <th>类别</th>
                  <th>商品原价</th>
                  <th>实际售价</th>
                  <th>折扣</th>
                  <th>月销量</th>
                  <th>购买顾客数</th>
                  <th>库存状态</th>
                  <th>是否包邮</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="product in products" :key="product.product_id" class="table-row">
                  <td :title="product.product_id">{{ truncateText(product.product_id, 12) }}</td>
                  <td :title="product.product_name">{{ truncateText(product.product_name, 25) }}</td>
                  <td>{{ product.brand_name }}</td>
                  <td>{{ product.category }}</td>
                  <td>¥{{ (Number(product.original_price) || 0).toFixed(2) }}</td>
                  <td>¥{{ (Number(product.price) || 0).toFixed(2) }}</td>
                  <td>{{ product.discount_rate }}%</td>
                  <td>{{ product.monthly_sales }}</td>
                  <td>{{ product.buy_customer_count || 0 }}</td>
                  <td><span :class="['status-tag', getStockStatusClass(product.stock_status)]">{{ product.stock_status }}</span></td>
                  <td>{{ product.is_free_shipping ? '是' : '否' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        
        <div class="pagination" v-if="productTotal > 0">
          <span class="page-info">显示 {{ products.length > 0 ? ((productPage - 1) * pageSize + 1) : 0 }}-{{ Math.min(productPage * pageSize, productTotal) }} 条，共 {{ productTotal }} 条</span>
          <div class="page-buttons">
            <button @click="changeProductPage(productPage - 1)" :disabled="productPage === 1">上一页</button>
            <button @click="changeProductPage(productPage + 1)" :disabled="productPage >= Math.ceil(productTotal / pageSize)">下一页</button>
          </div>
        </div>
        <div v-else class="empty-state">暂无商品数据</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import client from '../api/client'

// 响应式数据
const customerCount = ref(0)
const merchantCount = ref(0)
const productCount = ref(0)

// 数据展示相关状态
const activeTab = ref('customers')
const tabs = [
  { key: 'customers', name: '客户数据' },
  { key: 'merchants', name: '商家数据' },
  { key: 'products', name: '商品数据' }
]

// 分页设置
const pageSize = 20

// 客户数据
const customers = ref([])
const customerTotal = ref(0)
const customerPage = ref(1)
const customerFilters = ref({
  name: '',
  status: '',
  sort: 'created_at:desc'
})

// 商家数据
const merchants = ref([])
const merchantTotal = ref(0)
const merchantPage = ref(1)
const merchantFilters = ref({
  name: '',
  category: '',
  sort: 'created_at:desc'
})

// 商品数据
const products = ref([])
const productTotal = ref(0)
const productPage = ref(1)
const productFilters = ref({
  name: '',
  merchant_id: '',
  category: '',
  sort: 'created_at:desc'
})

// 用于下拉选择的所有商家列表
const allMerchants = ref([])

// 加载统计数据
const loadStatistics = async () => {
  try {
    const response = await client.get('/data/statistics')
    if (response.data) {
      customerCount.value = response.data.customers || 0
      merchantCount.value = response.data.merchants || 0
      productCount.value = response.data.products || 0
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
  }
}

// 加载所有数据
const loadAllData = async () => {
  // 先加载商家数据，因为产品数据需要商家信息
  await loadMerchants()
  // 加载当前选中标签页的数据
  if (activeTab.value === 'customers') {
    await loadCustomers()
  } else if (activeTab.value === 'products') {
    await loadProducts()
  }
}

// 加载客户数据
const loadCustomers = async () => {
  try {
    const params = {
      page: customerPage.value,
      page_size: pageSize,
      ...(customerFilters.value.name && { name: customerFilters.value.name }),
      ...(customerFilters.value.status && { status: customerFilters.value.status })
    }
    
    const response = await client.get('/data/customers', { params })
    if (response.data) {
      customers.value = response.data.data || []
      customerTotal.value = response.data.total || 0
    }
  } catch (error) {
    console.error('加载客户数据失败:', error)
  }
}

// 加载商家数据
const loadMerchants = async () => {
  try {
    const params = {
      page: merchantPage.value,
      page_size: pageSize,
      ...(merchantFilters.value.name && { name: merchantFilters.value.name }),
      ...(merchantFilters.value.category && { category: merchantFilters.value.category })
    }
    
    const response = await client.get('/data/merchants', { params })
    if (response.data) {
      merchants.value = response.data.data || []
      merchantTotal.value = response.data.total || 0
    }
    
    // 加载所有商家用于下拉选择
    const allMerchantsResponse = await client.get('/data/merchants', { 
      params: { page_size: 100, page: 1 }
    })
    if (allMerchantsResponse.data) {
      allMerchants.value = allMerchantsResponse.data.data || []
    }
  } catch (error) {
    console.error('加载商家数据失败:', error)
  }
}

// 加载商品数据
const loadProducts = async () => {
  try {
    const params = {
      page: productPage.value,
      page_size: pageSize,
      ...(productFilters.value.name && { name: productFilters.value.name }),
      ...(productFilters.value.merchant_id && { merchant_id: productFilters.value.merchant_id }),
      ...(productFilters.value.category && { category: productFilters.value.category })
    }
    
    const response = await client.get('/data/products', { params })
    if (response.data) {
      products.value = response.data.data || []
      productTotal.value = response.data.total || 0
    }
  } catch (error) {
    console.error('加载商品数据失败:', error)
  }
}

// 切换标签页
const switchTab = async (tab) => {
  activeTab.value = tab
  if (tab === 'customers') {
    await loadCustomers()
  } else if (tab === 'merchants') {
    await loadMerchants()
  } else if (tab === 'products') {
    await loadProducts()
  }
}

// 客户分页
const changeCustomerPage = async (page) => {
  customerPage.value = page
  await loadCustomers()
}

// 商家分页
const changeMerchantPage = async (page) => {
  merchantPage.value = page
  await loadMerchants()
}

// 商品分页
const changeProductPage = async (page) => {
  productPage.value = page
  await loadProducts()
}

// 根据ID获取商家名称
const getMerchantName = (merchantId) => {
  const merchant = allMerchants.value.find(m => m.id === merchantId)
  return merchant ? merchant.name : '未知商家'
}

// 截断文本
const truncateText = (text, maxLength) => {
  if (!text || text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}

// 获取库存状态样式类
const getStockStatusClass = (status) => {
  switch (status) {
    case '充足':
      return 'stock-abundant';
    case '一般':
      return 'stock-normal';
    case '紧张':
      return 'stock-low';
    case '缺货':
      return 'stock-out';
    default:
      return 'stock-normal';
  }
}

// 重置筛选条件
const resetFilters = (tab) => {
  if (tab === 'customers') {
    customerFilters.value.name = '';
    customerFilters.value.status = '';
    customerPage.value = 1;
  } else if (tab === 'merchants') {
    merchantFilters.value.name = '';
    merchantFilters.value.category = '';
    merchantPage.value = 1;
  } else if (tab === 'products') {
    productFilters.value.name = '';
    productFilters.value.merchant_id = '';
    productFilters.value.category = '';
    productPage.value = 1;
  }
}

const formatTime = (timeString) => {
  if (!timeString) return ''
  try {
    const date = new Date(timeString)
    return date.toLocaleString('zh-CN')
  } catch {
    return timeString
  }
}

// 监听筛选条件变化，自动重新加载数据
watch(customerFilters, () => {
  customerPage.value = 1
  loadCustomers()
}, { deep: true })

watch(merchantFilters, () => {
  merchantPage.value = 1
  loadMerchants()
}, { deep: true })

watch(productFilters, () => {
  productPage.value = 1
  loadProducts()
}, { deep: true })

// 组件挂载时加载数据
onMounted(async () => {
  await loadStatistics()
  await loadAllData()
})
</script>

<style>
/* 使用全局theme.css中的样式类 */
/* 数据概览样式 */
.data-overview {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-top: 12px;
}

.overview-card {
  background: var(--color-panel);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.overview-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.overview-card .count {
  font-size: 32px;
  font-weight: 700;
  color: var(--color-primary);
  margin-bottom: 8px;
}

.overview-card .label {
  font-size: 14px;
  color: var(--color-subtext);
}

/* 标签页样式 */
.data-tabs {
  background: var(--color-panel);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  overflow: hidden;
}

.tab-buttons {
  display: flex;
  background: var(--color-bg);
  border-bottom: 1px solid var(--border-color);
}

.tab-button {
  padding: 12px 24px;
  border: none;
  background: transparent;
  color: var(--color-subtext);
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s;
  border-bottom: 2px solid transparent;
}

.tab-button:hover {
  color: var(--color-primary);
  background: rgba(0, 0, 0, 0.02);
}

.tab-button.active {
  color: var(--color-primary);
  border-bottom-color: var(--color-primary);
  background: var(--color-panel);
}

.tab-content {
  padding: 16px;
}

/* 筛选区域样式 */
.filter-section {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.filter-input {
  flex: 1;
  min-width: 200px;
  padding: 8px 12px;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--color-bg);
  color: var(--color-text);
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--color-bg);
  color: var(--color-text);
  min-width: 150px;
}

/* 表格容器样式 */
.table-container {
  overflow-x: auto;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  margin-bottom: 16px;
  position: relative;
  max-height: 600px; /* 可调整的最大高度 */
}

/* 数据表格样式 */
.data-table {
  width: 100%;
  border-collapse: collapse;
  table-layout: fixed;
}

.data-table th {
  background: var(--color-bg);
  padding: 12px;
  text-align: left;
  font-weight: 600;
  color: var(--color-text);
  border-bottom: 2px solid var(--border-color);
  position: sticky;
  top: 0;
  z-index: 10;
  white-space: nowrap;
  min-width: 80px;
}



.data-table td {
  padding: 12px;
  border-bottom: 1px solid var(--border-color);
  color: var(--color-text);
  vertical-align: middle;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 设置列宽 */
.data-table th:nth-child(1),
.data-table td:nth-child(1) {
  min-width: 100px;
}

.data-table th:nth-child(2),
.data-table td:nth-child(2) {
  min-width: 150px;
}

.data-table th:nth-child(3),
.data-table td:nth-child(3),
.data-table th:nth-child(4),
.data-table td:nth-child(4),
.data-table th:nth-child(5),
.data-table td:nth-child(5) {
  min-width: 80px;
}

.data-table th:nth-child(6),
.data-table td:nth-child(6),
.data-table th:nth-child(7),
.data-table td:nth-child(7) {
  min-width: 140px;
}

.table-row:hover {
  background: rgba(0, 0, 0, 0.02);
  transition: background-color 0.2s ease;
}

/* 库存状态样式 */
.stock-abundant {
  background: rgba(82, 196, 26, 0.1);
  color: var(--color-success);
}

.stock-normal {
  background: rgba(250, 173, 20, 0.1);
  color: var(--color-warning);
}

.stock-low {
  background: rgba(245, 34, 45, 0.1);
  color: #f5222d;
}

.stock-out {
  background: rgba(153, 153, 153, 0.1);
  color: #999;
}

/* 为可点击单元格添加提示效果 */
.data-table td[title]:hover {
  background: rgba(0, 0, 0, 0.03);
  cursor: help;
}

/* 分页样式 */
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
}

.page-info {
  color: var(--color-subtext);
  font-size: 14px;
}

.page-buttons button {
  padding: 6px 12px;
  margin-left: 8px;
  border: 1px solid var(--border-color);
  background: var(--color-bg);
  color: var(--color-text);
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
}

.page-buttons button:hover:not(:disabled) {
  background: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}

.page-buttons button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 空状态样式 */
.empty-state {
  text-align: center;
  padding: 40px;
  color: var(--color-subtext);
  font-size: 14px;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .status-container {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }
  
  .status-info {
    flex-wrap: wrap;
  }
  
  .data-overview {
    grid-template-columns: 1fr;
  }
  
  .connection-details {
    flex-direction: column;
    gap: 8px;
  }
  
  .tab-buttons {
    flex-direction: column;
  }
  
  .tab-button {
    text-align: left;
  }
  
  .filter-section {
    flex-direction: column;
  }
  
  .filter-input, .filter-select {
    width: 100%;
  }
  
  .pagination {
    flex-direction: column;
    gap: 12px;
  }
  
  .data-table {
    display: block;
    overflow-x: auto;
  }
}
</style>
