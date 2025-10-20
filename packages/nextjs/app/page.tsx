"use client";

import Link from "next/link";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { Address } from "~~/components/scaffold-eth";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  return (
    <div className="min-h-screen flex flex-col bg-gradient-to-b from-base-100 to-base-200">
      <header className="container mx-auto px-6 py-8">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl md:text-4xl font-extrabold">Lancer Protocol</h1>
            <p className="text-sm text-base-content/60">Decentralized marketplaces & dispute resolution</p>
          </div>

          <div className="text-right">
            <p className="text-xs text-base-content/60">Connected:</p>
            <Address address={connectedAddress} />
          </div>
        </div>
      </header>

      <main className="container mx-auto px-6 flex-1">
        {/* Hero */}
        <section className="bg-base-100 rounded-2xl p-8 md:p-12 shadow-lg">
          <div className="md:flex md:items-center md:justify-between">
            <div className="md:flex-1">
              <h2 className="text-3xl md:text-4xl font-bold mb-4">Deploy your own on-chain marketplaces</h2>
              <p className="text-lg text-base-content/70 mb-6 max-w-3xl">
                Lancer Protocol allows anyone to deploy and manage decentralized marketplaces, whit integrated
                escrow system for payments and indexed on-chain data by Envio. While connect them to an 
                on-chain dispute resolution system.
              </p>

              <div className="flex flex-wrap gap-3">
                <Link href="/debug" className="btn btn-primary btn-md">
                  Open App
                </Link>

                <Link href="/blockexplorer" className="btn btn-outline btn-md">
                  Block Explorer
                </Link>

                <Link href="/about" className="btn btn-outline btn-md">
                  About
                </Link>

                <a
                  href="https://github.com/0xDarioSanchez/ETHG25"
                  target="_blank"
                  rel="noreferrer"
                  className="btn btn-outline btn-md"
                >
                  View on GitHub
                </a>
              </div>
            </div>

            <div className="mt-8 md:mt-0 md:ml-8 w-full md:w-96">
              <div className="bg-base-200 p-6 rounded-xl shadow-inner">
                <h4 className="font-semibold mb-2">More</h4>
                <p className="text-sm text-base-content/70">Do you want to learn more? Go to the <a href="/about" className="font-semibold underline">About</a> section.</p>
              </div>
            </div>
          </div>
        </section>

        {/* Features */}
        <section className="mt-10 grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-base-100 p-6 rounded-2xl shadow hover:shadow-md transition">
            <h3 className="font-semibold mb-2">Deploy Marketplaces</h3>
            <p className="text-sm text-base-content/70 mb-4">Create customizable marketplace instances per owner with built-in payment handling.</p>
            <Link href="/debug" className="btn btn-sm btn-outline">Go to App</Link>
          </div>

          <div className="bg-base-100 p-6 rounded-2xl shadow hover:shadow-md transition">
            <h3 className="font-semibold mb-2">Dispute Resolution</h3>
            <p className="text-sm text-base-content/70 mb-4">Use the ProtocolContract to manage disputes and judge payouts in a decentralized way.</p>
            <Link href="/debug" className="btn btn-sm btn-outline">Inspect Contracts</Link>
          </div>

          <div className="bg-base-100 p-6 rounded-2xl shadow hover:shadow-md transition">
            <h3 className="font-semibold mb-2">Indexed Data</h3>
            <p className="text-sm text-base-content/70 mb-4">Connect to Envio and Hasura for fast access to on-chain events and entity queries.</p>
            <Link href="/envio" className="btn btn-sm btn-outline">Open Envio</Link>
          </div>
  </section>

 

        {/* CTA */}
        <section className="mt-12 bg-base-200 rounded-2xl p-8 text-center">
          <h3 className="text-2xl font-bold mb-3">Ready to build?</h3>
          <p className="text-base text-base-content/70 mb-6">Start by deploying your own marketplace and interact with it.</p>
          <div className="flex items-center justify-center gap-3">
            <Link href="/debug" className="btn btn-primary btn-lg">Launch App</Link>
            <Link href="/envio" className="btn btn-ghost btn-lg">View Indexer</Link>
          </div>
        </section>
      </main>

      <footer className="mt-12 py-8 border-t border-base-300">
        <div className="container mx-auto px-6 flex items-center justify-between">
          <div className="text-sm text-base-content/70">© {new Date().getFullYear()} Lancer Protocol</div>
          <div className="flex items-center gap-4">
            <a href="https://github.com/0xDarioSanchez/ETHG25" target="_blank" rel="noreferrer" className="text-sm">GitHub</a>
            <Link href="/debug" className="text-sm">App</Link>
            <Link href="/envio" className="text-sm">Envio</Link>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Home;
