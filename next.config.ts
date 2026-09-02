import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  poweredByHeader: false,
  images: { remotePatterns: [] },
  experimental: { optimizePackageImports: ['lucide-react'] }
};
export default nextConfig;
