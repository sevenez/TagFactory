import axios from 'axios'

const client = axios.create({
  baseURL: 'http://127.0.0.1:8002',
  timeout: 5000
})

export default client
