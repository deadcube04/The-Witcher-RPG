import { Button, Input, InputNumber, Select } from 'antd'
import { useId, type ReactNode } from 'react'

type ButtonProps = { children: ReactNode; onClick?: () => void; disabled?: boolean; loading?: boolean; submit?: boolean; secondary?: boolean; danger?: boolean }
export function RpgButton({ children, onClick, disabled, loading, submit, secondary, danger }: ButtonProps) {
  return <Button htmlType={submit ? 'submit' : 'button'} onClick={onClick} disabled={disabled} loading={loading} danger={danger}
    type={secondary ? 'default' : 'primary'} className={'min-h-11! rounded-sm! px-5! font-semibold! shadow-none! focus-visible:outline-2! focus-visible:outline-offset-4! ' + (!secondary && !danger && !disabled ? 'bg-(--accent)! text-(--canvas)!' : '')}>{children}</Button>
}
type FieldProps = { label: string; error?: string; hint?: string; children: (id: string) => ReactNode }
export function RpgField({ label, error, hint, children }: FieldProps) {
  const id = useId()
  return <div className="min-w-0 space-y-2"><label htmlFor={id} className="block text-sm font-semibold">{label}</label>
    {children(id)}{hint && <p className="text-xs opacity-75">{hint}</p>}
    {error && <p id={id + '-error'} role="alert" className="text-sm text-red-400">{error}</p>}</div>
}
type InputProps = { label: string; value: string; onChange: (value: string) => void; onBlur?: () => void; disabled?: boolean; error?: string; multiline?: boolean; hint?: string }
export function RpgInput({ label, value, onChange, onBlur, disabled, error, multiline, hint }: InputProps) {
  return <RpgField label={label} error={error} hint={hint}>{(id) => multiline
    ? <Input.TextArea id={id} value={value} onChange={(event) => onChange(event.target.value)} onBlur={onBlur} disabled={disabled} rows={4} aria-invalid={!!error} aria-describedby={error ? id + '-error' : undefined} className="rounded-sm!" />
    : <Input id={id} value={value} onChange={(event) => onChange(event.target.value)} onBlur={onBlur} disabled={disabled} aria-invalid={!!error} aria-describedby={error ? id + '-error' : undefined} className="min-h-11! rounded-sm!" />}</RpgField>
}
export type SelectOption = { value: string; label: string; disabled?: boolean }
export function RpgSelect({ label, value, onChange, options, disabled }: { label: string; value: string; onChange: (value: string) => void; options: SelectOption[]; disabled?: boolean }) {
  return <RpgField label={label}>{(id) => <Select id={id} value={value} onChange={onChange} options={options} disabled={disabled} className="min-h-11! w-full!" virtual={false} />}</RpgField>
}
export function RpgNumber({ label, value, onChange, min, max, disabled }: { label: string; value: number; onChange: (value: number) => void; min?: number; max?: number; disabled?: boolean }) {
  return <RpgField label={label}>{(id) => <InputNumber id={id} value={value} onChange={(next) => onChange(next ?? 0)} min={min} max={max} precision={0} disabled={disabled} className="min-h-11! w-full! rounded-sm!" />}</RpgField>
}
export function RpgInlineNumber({ label, value, onChange, min, max }: { label: string; value: number; onChange: (value: number) => void; min?: number; max?: number }) {
  return <InputNumber aria-label={label} value={value} onChange={(next) => { if (next !== null) onChange(next) }} min={min} max={max} precision={0}
    className="min-h-10! w-20! rounded-sm! [&_input]:text-center!" />
}
export function RpgInlineSelect({ label, value, onChange, options }: { label: string; value: string; onChange: (value: string) => void; options: SelectOption[] }) {
  return <Select aria-label={label} value={value} onChange={onChange} options={options} virtual={false}
    className="min-h-10! w-32! [&_.ant-select-selection-item]:text-center!" />
}
