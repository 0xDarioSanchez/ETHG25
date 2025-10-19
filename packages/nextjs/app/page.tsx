"use client";

import Link from "next/link";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { Address } from "~~/components/scaffold-eth";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  return (
    <>
      <div className="min-h-screen flex flex-col">
        <header className="container mx-auto px-6 py-8">
          <div className="flex items-center justify-between">
            <h1 className="text-3xl md:text-4xl font-extrabold">Welcome to Lancer Protocol</h1>
            <div className="text-right">
              <p className="text-sm text-muted">Connected</p>
              <Address address={connectedAddress} />
            </div>
          </div>
        </header>

        <main className="container mx-auto px-6 flex-1">
          <section className="bg-gradient-to-r from-primary/10 to-secondary/5 rounded-2xl p-8 md:p-12 shadow-md">
            <div className="md:flex md:items-center md:justify-between">
              <div className="md:flex-1">
                <h2 className="text-2xl md:text-3xl font-bold mb-3">Build your own decentralized marketplaces</h2>
                <p className="text-base text-muted mb-4 max-w-2xl pl-6">
                  Lancer Protocol is a decentralized freelance marketplace built on Ethereum<br />
                  It allows you to deploy your own on-chain marketplaces with a few clicks<br />
                  While your market access a global system of decentralized dispute resolution
                </p>

                <div className="flex flex-wrap gap-3">
                  <Link href="/debug" className="btn btn-primary btn-md flex items-center gap-2">
                    Go to Lancer App
                  </Link>

                  <Link href="/blockexplorer" className="btn btn-ghost btn-md flex items-center gap-2">
                    Open Block Explorer
                  </Link>

                  <a
                    href="https://github.com/0xDarioSanchez/ETHG25"
                    target="_blank"
                    rel="noreferrer"
                    className="btn btn-outline btn-md"
                  >
                    View Repo
                  </a>
                </div>
              </div>

              <div className="mt-6 md:mt-0 md:ml-8 w-full md:w-80">
                <div className="bg-base-100 p-4 rounded-xl shadow-inner">
                  <p className="text-sm text-muted mb-2">Quick tip</p>
                  <p className="text-sm">Edit <span className="font-semibold">ProtocolContract.sol</span> in <code className="font-mono">packages/hardhat/contracts</code> and re-run your local tests.</p>
                </div>
              </div>
            </div>
          </section>

          <section className="mt-8 grid gap-6 md:grid-cols-2">
            <div className="flex flex-col bg-base-100 p-6 rounded-2xl shadow-lg">
              <h3 className="font-bold text-lg mb-2">Debug Contracts</h3>
              <p className="text-sm text-muted mb-4">Run and inspect local contract deployments, transactions and traces.</p>
              <Link href="/debug" className="mt-auto btn btn-primary">Open Debug</Link>
            </div>

            <div className="flex flex-col bg-base-100 p-6 rounded-2xl shadow-lg">
              <h3 className="font-bold text-lg mb-2">Block Explorer</h3>
              <p className="text-sm text-muted mb-4">Browse your local chain's transactions, receipts and events.</p>
              <Link href="/blockexplorer" className="mt-auto btn btn-secondary">Open Explorer</Link>
            </div>
          </section>
        </main>


      </div>
    </>
  );
};

export default Home;
