import sys
import os

# 添加项目根目录到Python路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# 修改相对导入为绝对导入
import importlib.util

if __name__ == "__main__":
    # 直接运行main.py但先设置路径
    import main