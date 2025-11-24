<template>
  <div class="test-container">
    <h2>数据加载测试</h2>
    
    <div class="test-section">
      <h3>连接状态测试</h3>
      <button @click="testConnection" :disabled="loading">
        {{ loading ? '测试中...' : '测试连接' }}
      </button>
      <div v-if="connectionResult" class="result">
        <pre>{{ JSON.stringify(connectionResult, null, 2) }}</pre>
      </div>
    </div>
    
    <div class="test-section">
      <h3>统计数据测试</h3>
      <button @click="testStatistics" :disabled="loading">
        {{ loading ? '测试中...' : '获取统计' }}
      </button>
      <div v-if="statisticsResult" class="result">
        <pre>{{ JSON.stringify(statisticsResult, null, 2) }}</pre>
      </div>
    </div>
    
    <div class="test-section">
      <h3>客户数据测试</h3>
      <button @click="testCustomers" :disabled="loading">
        {{ loading ? '测试中...' : '获取客户' }}
      </button>
      <div v-if="customersResult" class="result">
        <p>总计: {{ customersResult.total }} 条</p>
        <table v-if="customersResult.data && customersResult.data.length > 0">
          <thead>
            <tr>
              <th>客户ID</th>
              <th>手机号</th>
              <th>性别</th>
              <th>年龄</th>
              <th>消费金额</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="customer in customersResult.data" :key="customer.customer_id">
              <td>{{ customer.customer_id }}</td>
              <td>{{ customer.phone }}</td>
              <td>{{ customer.gender }}</td>
              <td>{{ customer.age }}</td>
              <td>{{ customer.total_consume }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
    <div class="test-section">
      <h3>商家数据测试</h3>
      <button @click="testMerchants" :disabled="loading">
        {{ loading ? '测试中...' : '获取商家' }}
      </button>
      <div v-if="merchantsResult" class="result">
        <p>总计: {{ merchantsResult.total }} 条</p>
        <table v-if="merchantsResult.data && merchantsResult.data.length > 0">
          <thead>
            <tr>
              <th>商家ID</th>
              <th>商家名称</th>
              <th>城市</th>
              <th>评分</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="merchant in merchantsResult.data" :key="merchant.seller_id">
              <td>{{ merchant.seller_id }}</td>
              <td>{{ merchant.seller_name }}</td>
              <td>{{ merchant.city }}</td>
              <td>{{ merchant.seller_rating }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
    <div class="test-section">
      <h3>商品数据测试</h3>
      <button @click="testProducts" :disabled="loading">
        {{ loading ? '测试中...' : '获取商品' }}
      </button>
      <div v-if="productsResult" class="result">
        <p>总计: {{ productsResult.total }} 条</p>
        <table v-if="productsResult.data && productsResult.data.length > 0">
          <thead>
            <tr>
              <th>商品ID</th>
              <th>商品名称</th>
              <th>品牌</th>
              <th>价格</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in productsResult.data" :key="product.product_id">
              <td>{{ product.product_id }}</td>
              <td>{{ product.product_name }}</td>
              <td>{{ product.brand_name }}</td>
              <td>{{ product.price }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import client from '../api/client'

const loading = ref(false)
const connectionResult = ref(null)
const statisticsResult = ref(null)
const customersResult = ref(null)
const merchantsResult = ref(null)
const productsResult = ref(null)

const testConnection = async () => {
  loading.value = true
  try {
    const response = await client.get('/data/connection/status')
    connectionResult.value = response.data
  } catch (error) {
    connectionResult.value = { error: error.message }
  } finally {
    loading.value = false
  }
}

const testStatistics = async () => {
  loading.value = true
  try {
    const response = await client.get('/data/statistics')
    statisticsResult.value = response.data
  } catch (error) {
    statisticsResult.value = { error: error.message }
  } finally {
    loading.value = false
  }
}

const testCustomers = async () => {
  loading.value = true
  try {
    const response = await client.get('/data/customers?page=1&page_size=5')
    customersResult.value = response.data
  } catch (error) {
    customersResult.value = { error: error.message }
  } finally {
    loading.value = false
  }
}

const testMerchants = async () => {
  loading.value = true
  try {
    const response = await client.get('/data/merchants?page=1&page_size=5')
    merchantsResult.value = response.data
  } catch (error) {
    merchantsResult.value = { error: error.message }
  } finally {
    loading.value = false
  }
}

const testProducts = async () => {
  loading.value = true
  try {
    const response = await client.get('/data/products?page=1&page_size=5')
    productsResult.value = response.data
  } catch (error) {
    productsResult.value = { error: error.message }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.test-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.test-section {
  margin-bottom: 30px;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: #f9f9f9;
}

.test-section h3 {
  margin-top: 0;
  color: #333;
}

button {
  background: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  margin-bottom: 10px;
}

button:disabled {
  background: #6c757d;
  cursor: not-allowed;
}

button:hover:not(:disabled) {
  background: #0056b3;
}

.result {
  margin-top: 10px;
  padding: 10px;
  background: white;
  border-radius: 4px;
  border: 1px solid #ddd;
}

pre {
  white-space: pre-wrap;
  word-wrap: break-word;
  margin: 0;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

th {
  background: #f2f2f2;
  font-weight: bold;
}

p {
  margin: 10px 0;
  font-weight: bold;
}
</style>