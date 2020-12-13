import { useBackend } from '../backend';
import { AnimatedNumber, Button, Dropdown, Input, NumberInput, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export const NtosAcctManager = (props, context) => {
  return (
    <NtosWindow
      width={520}
      height={620}
      resizable>
      <NtosWindow.Content scrollable>
        <NtosBankAcctManagerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosBankAcctManagerContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    authed,
    jobs = [],
    accounts = [],
  } = data;
  return (
    <Section
      title={"Account Management"}
      buttons={(
        <Button.Input
          defaultValue={"New Account"}
          currentValue={"Account Holder"}
          content={"New Account"}
          onCommit={(e, value) => act('PRG_new_account', {
            account_name: value,
          })} />
      )}>
      <Table>
        <Table.Row header>
          <Table.Cell>
            Close
          </Table.Cell>
          <Table.Cell>
            ID
          </Table.Cell>
          <Table.Cell>
            Holder
          </Table.Cell>
          <Table.Cell>
            Paycheck Grade
          </Table.Cell>
          <Table.Cell>
            Balance
          </Table.Cell>
        </Table.Row>
        {accounts.map(account => (
          <Table.Row
            key={account.id}
            className="candystripe">
            <Table.Cell collapsing>
              <Button
                icon={"window-close"}
                color={"bad"}
                onClick={() => act('PRG_close_acct', {
                  selected_account: account.ref,
                })} />
            </Table.Cell>
            <Table.Cell collapsing>
              <NumberInput
                minValue={111111}
                maxValue={999999}
                disabled={!authed}
                value={account.id}
                onChange={(e, value) => act('PRG_change_id', {
                  selected_account: account.ref,
                  new_id: value,
                })} />
            </Table.Cell>
            <Table.Cell>
              <Input
                fluid
                value={account.holder}
                disabled={!authed}
                onChange={(e, value) => act('PRG_change_holder', {
                  selected_account: account.ref,
                  new_holder: value,
                })} />
            </Table.Cell>
            <Table.Cell collapsing>
              <Dropdown
                options={jobs}
                disabled={!authed}
                selected={account.job}
                onSelected={value => act('PRG_change_job', {
                  selected_account: account.ref,
                  new_job: value,
                })} />
            </Table.Cell>
            <Table.Cell collapsing>
              <AnimatedNumber
                value={account.balance}
                format={value => value + 'cr'} />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
