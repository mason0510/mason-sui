import Image from "next/image";
import { NavItem } from "./NavItem";
import { SuiConnect } from "./SuiConnect";
import {
  ADDRESS_URL,
  MODULE_URL
} from "../config/constants";

export function NavBar() {
  return (
    <nav className="navbar py-4 px-4 bg-base-100">
      <div className="flex-1">
        <a href="http://movedid.build" target="_blank">
          <Image src="/logo.png" width={64} height={64} alt="logo" />
        </a>
        <ul className="menu menu-horizontal p-0 ml-5">
          <NavItem href="/" title="Dashboard" />
          <NavItem href="/stake" title="Stake" />
          <NavItem href="/claim" title="Claim" />
          <NavItem href="/unStake" title="UnStake" />
          <li className="font-sans font-semibold text-lg">
            <a href={MODULE_URL} target="_blank">Contract on Explorer</a>
          </li>
          <li className="font-sans font-semibold text-lg">
            <a href={ADDRESS_URL} target="_blank">Address on Explorer</a>
          </li>
        </ul>
      </div>
      <SuiConnect />
    </nav>
  );
}
