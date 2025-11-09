/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    // 确保服务器组件优先
    serverActions: {
      bodySizeLimit: '2mb',
    },
  },
};

export default nextConfig;
