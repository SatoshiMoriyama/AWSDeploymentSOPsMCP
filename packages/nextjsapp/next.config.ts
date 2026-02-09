import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  output: 'export', // 静的エクスポートを有効化
  images: {
    unoptimized: true, // S3/CloudFrontでは画像最適化が不要
  },
};

export default nextConfig;
