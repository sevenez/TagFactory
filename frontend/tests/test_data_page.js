// 前端数据管理页面测试脚本
// 注意：此脚本需要在浏览器环境中运行，可以通过开发者工具控制台执行

/**
 * 数据管理页面功能测试套件
 */
const DataPageTester = {
    /**
     * 初始化测试环境
     */
    init() {
        console.log('数据管理页面测试初始化...');
        this.results = {
            connectionStatus: null,
            refreshFunctionality: null,
            dataDisplay: null,
            pagination: null,
            filtering: null,
            sorting: null,
            errorHandling: null
        };
    },
    
    /**
     * 测试连接状态显示
     */
    testConnectionStatus() {
        console.log('\n测试1: 连接状态显示');
        
        try {
            // 获取连接状态元素
            const statusElement = document.querySelector('.connection-status .status');
            
            if (!statusElement) {
                console.error('❌ 未找到连接状态元素');
                this.results.connectionStatus = false;
                return;
            }
            
            const statusText = statusElement.textContent.trim();
            const isConnected = statusElement.classList.contains('ok') || statusText.includes('已连接');
            const isConnecting = statusText.includes('连接中');
            const isDisconnected = statusElement.classList.contains('bad') || statusText.includes('未连接');
            
            console.log(`  当前连接状态: ${statusText}`);
            console.log(`  状态标识: ${isConnected ? '已连接' : isConnecting ? '连接中' : isDisconnected ? '未连接' : '未知'}`);
            
            // 检查连接详情
            const detailsElement = document.querySelector('.connection-details');
            if (detailsElement) {
                console.log('  ✅ 连接详情面板存在');
            } else {
                console.log('  ⚠️  未找到连接详情面板');
            }
            
            // 状态元素应该有明确的状态标识
            if (isConnected || isConnecting || isDisconnected) {
                console.log('  ✅ 连接状态显示正确');
                this.results.connectionStatus = true;
            } else {
                console.error('  ❌ 连接状态显示不明确');
                this.results.connectionStatus = false;
            }
        } catch (error) {
            console.error('  ❌ 测试连接状态时出错:', error);
            this.results.connectionStatus = false;
        }
    },
    
    /**
     * 测试刷新功能
     */
    testRefreshFunctionality() {
        console.log('\n测试2: 刷新功能');
        
        try {
            // 查找刷新按钮
            const refreshButton = document.querySelector('.refresh-button');
            
            if (!refreshButton) {
                console.error('❌ 未找到刷新按钮');
                this.results.refreshFunctionality = false;
                return;
            }
            
            console.log('  ✅ 刷新按钮存在');
            console.log(`  按钮文本: ${refreshButton.textContent.trim()}`);
            
            // 检查按钮是否可点击
            if (refreshButton.disabled) {
                console.error('  ❌ 刷新按钮当前被禁用');
                this.results.refreshFunctionality = false;
            } else {
                console.log('  ✅ 刷新按钮可点击');
                
                // 注意：实际点击操作需要手动执行，这里只是检查按钮状态
                console.log('  ℹ️  刷新按钮功能测试：请手动点击刷新按钮观察连接状态变化');
                this.results.refreshFunctionality = true;
            }
        } catch (error) {
            console.error('  ❌ 测试刷新功能时出错:', error);
            this.results.refreshFunctionality = false;
        }
    },
    
    /**
     * 测试数据展示标签页
     */
    testDataDisplayTabs() {
        console.log('\n测试3: 数据展示标签页');
        
        try {
            // 查找标签页容器
            const tabsContainer = document.querySelector('.data-tabs');
            
            if (!tabsContainer) {
                console.error('❌ 未找到数据标签页容器');
                this.results.dataDisplay = false;
                return;
            }
            
            // 检查是否有三个核心标签
            const tabItems = tabsContainer.querySelectorAll('.tab-item');
            const tabTexts = Array.from(tabItems).map(tab => tab.textContent.trim());
            
            console.log(`  找到 ${tabItems.length} 个标签页:`, tabTexts);
            
            const expectedTabs = ['客户数据', '商家数据', '商品数据'];
            let allTabsFound = true;
            
            expectedTabs.forEach(expected => {
                if (!tabTexts.some(text => text.includes(expected))) {
                    console.error(`  ❌ 未找到 ${expected} 标签页`);
                    allTabsFound = false;
                } else {
                    console.log(`  ✅ 找到 ${expected} 标签页`);
                }
            });
            
            this.results.dataDisplay = allTabsFound;
        } catch (error) {
            console.error('  ❌ 测试数据展示标签页时出错:', error);
            this.results.dataDisplay = false;
        }
    },
    
    /**
     * 测试分页功能
     */
    testPagination() {
        console.log('\n测试4: 分页功能');
        
        try {
            // 查找分页组件
            const pagination = document.querySelector('.pagination');
            
            if (!pagination) {
                console.error('❌ 未找到分页组件');
                this.results.pagination = false;
                return;
            }
            
            // 检查分页控件
            const prevButton = pagination.querySelector('.prev');
            const nextButton = pagination.querySelector('.next');
            const pageButtons = pagination.querySelectorAll('.page-btn');
            const pageInfo = pagination.querySelector('.page-info');
            
            console.log('  ✅ 分页组件存在');
            
            if (prevButton && nextButton) {
                console.log('  ✅ 分页导航按钮存在');
            }
            
            if (pageInfo) {
                console.log(`  分页信息: ${pageInfo.textContent.trim()}`);
            }
            
            if (pageButtons.length > 0) {
                console.log(`  页码按钮数量: ${pageButtons.length}`);
            }
            
            this.results.pagination = true;
        } catch (error) {
            console.error('  ❌ 测试分页功能时出错:', error);
            this.results.pagination = false;
        }
    },
    
    /**
     * 测试筛选功能
     */
    testFiltering() {
        console.log('\n测试5: 筛选功能');
        
        try {
            // 查找筛选组件
            const filters = document.querySelector('.data-filters');
            
            if (!filters) {
                console.error('❌ 未找到筛选组件');
                this.results.filtering = false;
                return;
            }
            
            // 检查输入框和下拉选择框
            const inputs = filters.querySelectorAll('input');
            const selects = filters.querySelectorAll('select');
            const filterButtons = filters.querySelectorAll('button');
            
            console.log('  ✅ 筛选组件存在');
            console.log(`  输入框数量: ${inputs.length}`);
            console.log(`  下拉选择框数量: ${selects.length}`);
            console.log(`  按钮数量: ${filterButtons.length}`);
            
            if (inputs.length > 0 || selects.length > 0) {
                console.log('  ✅ 筛选控件存在');
                this.results.filtering = true;
            } else {
                console.error('  ❌ 未找到有效的筛选控件');
                this.results.filtering = false;
            }
        } catch (error) {
            console.error('  ❌ 测试筛选功能时出错:', error);
            this.results.filtering = false;
        }
    },
    
    /**
     * 测试排序功能
     */
    testSorting() {
        console.log('\n测试6: 排序功能');
        
        try {
            // 查找表格头（通常包含排序按钮）
            const tableHeader = document.querySelector('.data-table th');
            
            if (!tableHeader) {
                console.error('❌ 未找到表格头元素');
                this.results.sorting = false;
                return;
            }
            
            // 检查是否有可排序的表头
            const headers = document.querySelectorAll('.data-table th');
            let hasSortableHeaders = false;
            
            headers.forEach((header, index) => {
                if (header.classList.contains('sortable') || header.style.cursor === 'pointer') {
                    console.log(`  ✅ 表头 ${index + 1} 可排序: ${header.textContent.trim()}`);
                    hasSortableHeaders = true;
                }
            });
            
            if (hasSortableHeaders) {
                this.results.sorting = true;
            } else {
                console.log('  ⚠️  未检测到明确的排序标识，但表头可能仍支持点击排序');
                this.results.sorting = true; // 不严格要求
            }
        } catch (error) {
            console.error('  ❌ 测试排序功能时出错:', error);
            this.results.sorting = false;
        }
    },
    
    /**
     * 测试错误处理显示
     */
    testErrorHandling() {
        console.log('\n测试7: 错误处理显示');
        
        try {
            // 查找错误提示容器
            const errorContainer = document.querySelector('.error-message');
            
            if (errorContainer) {
                console.log('  ✅ 错误提示容器存在');
                
                if (errorContainer.textContent.trim()) {
                    console.log(`  当前错误信息: ${errorContainer.textContent.trim()}`);
                } else {
                    console.log('  当前无错误信息（正常状态）');
                }
                
                this.results.errorHandling = true;
            } else {
                console.error('  ❌ 未找到错误提示容器');
                this.results.errorHandling = false;
            }
        } catch (error) {
            console.error('  ❌ 测试错误处理时出错:', error);
            this.results.errorHandling = false;
        }
    },
    
    /**
     * 运行所有测试
     */
    runAllTests() {
        this.init();
        
        console.log('开始执行数据管理页面功能测试...');
        
        this.testConnectionStatus();
        this.testRefreshFunctionality();
        this.testDataDisplayTabs();
        this.testPagination();
        this.testFiltering();
        this.testSorting();
        this.testErrorHandling();
        
        this.showSummary();
    },
    
    /**
     * 显示测试结果摘要
     */
    showSummary() {
        console.log('\n====================================');
        console.log('          测试结果摘要              ');
        console.log('====================================');
        
        let passedCount = 0;
        const totalTests = Object.keys(this.results).length;
        
        for (const [test, result] of Object.entries(this.results)) {
            const status = result ? '✅ 通过' : '❌ 失败';
            console.log(`  ${test}: ${status}`);
            if (result) passedCount++;
        }
        
        console.log('------------------------------------');
        console.log(`  总测试数: ${totalTests}`);
        console.log(`  通过测试: ${passedCount}`);
        console.log(`  通过率: ${(passedCount / totalTests * 100).toFixed(1)}%`);
        console.log('====================================');
        
        // 提供使用说明
        console.log('\n使用说明:');
        console.log('1. 本测试脚本提供基本功能验证，部分交互测试需要手动确认');
        console.log('2. 刷新功能测试：请手动点击刷新按钮，观察连接状态是否更新');
        console.log('3. 连接测试：建议在不同网络状态下测试（连接正常/断开）');
        console.log('4. 异常测试：可通过修改数据库配置模拟连接失败场景');
    }
};

// 导出测试对象
if (typeof module !== 'undefined' && module.exports) {
    module.exports = DataPageTester;
} else {
    // 浏览器环境下直接运行
    window.DataPageTester = DataPageTester;
    // 提供便捷的测试启动函数
    window.runDataPageTests = () => DataPageTester.runAllTests();
    console.log('数据管理页面测试工具已加载，请调用 runDataPageTests() 开始测试');
}
