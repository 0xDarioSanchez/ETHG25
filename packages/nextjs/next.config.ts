import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async headers() {
    return [
      {
        source: "/(.*)",
        headers: [
          {
            key: "Content-Security-Policy",
            value: `
            default-src 'self' data: blob: https://*;
            script-src 'self' 'unsafe-eval' 'unsafe-inline' data: blob: https://*;
            style-src 'self' 'unsafe-inline' https://*;
            img-src 'self' data: blob: https://*;
            connect-src 'self' https://* http://127.0.0.1:* http://localhost:* wss://*;
            frame-src 'self' https://*;
            font-src 'self' data: https://*;
          `.replace(/\s{2,}/g, ' '),
          },
        ],
      },
    ];
  },
  reactStrictMode: true,
  devIndicators: false,
  typescript: {
    ignoreBuildErrors: process.env.NEXT_PUBLIC_IGNORE_BUILD_ERROR === "true",
  },
  eslint: {
    ignoreDuringBuilds: process.env.NEXT_PUBLIC_IGNORE_BUILD_ERROR === "true",
  },
  webpack: config => {
    config.resolve.fallback = {
    ...config.resolve.fallback,
    fs: false,
    net: false,
    tls: false,
    "async-function": require.resolve("async-function"),
    "generator-function": require.resolve("generator-function"),
    "async-generator-function": require.resolve("async-generator-function"),
  };
    config.externals.push("pino-pretty", "lokijs", "encoding");
    return config;
  },
};

const isIpfs = process.env.NEXT_PUBLIC_IPFS_BUILD === "true";

if (isIpfs) {
  nextConfig.output = "export";
  nextConfig.trailingSlash = true;
  nextConfig.images = {
    unoptimized: true,
  };
}

module.exports = nextConfig;


