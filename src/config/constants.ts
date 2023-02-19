export const NFT_STORAGE_KEY = process.env.NEXT_PUBLIC_NFT_STORAGE_KEY!;
export const TreasureAddress = process.env.NEXT_PUBLIC_Treasure_Address!;
export const TABLE_NAME = process.env.NEXT_PUBLIC_Tables_Name!;
export const SUPABASE_KEY = process.env.NEXT_PUBLIC_SUPABASE_KEY!;
export const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL!;
export const SUI_PACKAGE = process.env.NEXT_PUBLIC_DAPP_PACKAGE!; // changed here.
export const SUI_MODULE = process.env.NEXT_PUBLIC_DAPP_MODULE!; // changed here.
export const NETWORK = process.env.NEXT_PUBLIC_SUI_NETWORK!;
export const SUI_ADDRESS = process.env.NEXT_OWNER_SUI_NETWORK!;
export const OwnerAddress = process.env.NEXT_OWNER_SUI_NETWORK1!;
export const OwnerAddress2 = process.env.NEXT_OWNER_SUI_NETWORK2!;
export const MODULE_URL = "https://explorer.sui.io/object/" + SUI_PACKAGE + "?network=" + NETWORK
export const ADDRESS_URL = "https://explorer.sui.io/address/" +SUI_ADDRESS + "?network=" + NETWORK
