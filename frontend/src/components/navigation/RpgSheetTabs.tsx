import { Tabs } from 'antd'
import type { ReactNode } from 'react'

export type SheetTab = { key: string; label: string; icon: ReactNode; children: ReactNode }
export function RpgSheetTabs({ items }: { items: SheetTab[] }) {
  return <Tabs defaultActiveKey={items[0]?.key} tabPlacement="end" animated={false}
    className="min-w-0! [&_.ant-tabs-nav]:w-12! [&_.ant-tabs-nav]:shrink-0! [&_.ant-tabs-nav]:border-0! [&_.ant-tabs-nav::before]:border-0! [&_.ant-tabs-tab]:m-0! [&_.ant-tabs-tab]:mb-3! [&_.ant-tabs-tab]:min-h-16! [&_.ant-tabs-tab]:justify-center! [&_.ant-tabs-tab]:rounded-r-xl! [&_.ant-tabs-tab]:border! [&_.ant-tabs-tab]:border-(--edge)! [&_.ant-tabs-tab]:bg-(--canvas)! [&_.ant-tabs-tab]:px-3! [&_.ant-tabs-tab-active]:bg-(--panel)! [&_.ant-tabs-tab-active]:text-(--accent)! [&_.ant-tabs-content-holder]:min-w-0! [&_.ant-tabs-content-holder]:rounded-l-2xl! [&_.ant-tabs-content-holder]:border! [&_.ant-tabs-content-holder]:border-(--edge)! [&_.ant-tabs-content-holder]:bg-(--panel)! [&_.ant-tabs-tabpane]:min-h-[480px]! [&_.ant-tabs-tabpane]:p-4! md:[&_.ant-tabs-tabpane]:min-h-[640px]! md:[&_.ant-tabs-tabpane]:p-7!"
    items={items.map(({ key, label, icon, children }) => ({ key, forceRender: true,
      label: <span title={label} className="flex items-center justify-center text-xl">{icon}<span className="sr-only">{label}</span></span>,
      children: <section className="min-h-[480px] rounded-l-2xl border border-(--edge) bg-(--panel) p-4 text-(--ink) md:min-h-[720px] md:p-6 xl:min-h-[1000px]"><h3 className="mb-6 border-b border-(--edge) pb-4 font-sans text-xl font-semibold">{label}</h3>{children}</section>,
    }))} />
}
