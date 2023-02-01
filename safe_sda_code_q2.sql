with all_transactions as
(
select 
    et."from" as safe_wallet,
    et.tx_hash as safe_transactions
from ethereum.traces et
where et.success = True 
    and substring(et."input" for 4) in (
        '\x6a761202', -- execTransaction
        '\x468721a7', -- execTransactionFromModule
        '\x5229073f'  -- execTransactionFromModuleReturnData
    ) 
    AND et.call_type = 'delegatecall'
	AND et.to in (  -- mastercopies
	    '\x8942595A2dC5181Df0465AF0D7be08c8f23C93af', -- 0.1.0
	    '\xb6029EA3B2c51D09a50B53CA8012FeEB05bDa35A', -- 1.0.0
	    '\xaE32496491b53841efb51829d6f886387708F99B', -- 1.1.0
	    '\x34CfAC646f301356fAa8B21e94227e3583Fe3F5F', -- 1.1.1
	    '\x6851d6fdfafd08c0295c392436245e5bc78b0185', -- 1.2.0
	    '\xd9db270c1b5e3bd161e8c8503c55ceabee709552',  -- 1.3.0
	    '\x3e5c63644e683549055b9be8653de26e0b4cd36e'  -- 1.3.0L2
	) 
)

select
    s.address,
    count(distinct at.safe_transactions)
from gnosis_safe.view_safes s 
left join all_transactions at on s.address = at.safe_wallet
-- where at.safe_wallet is null
group by 1
having count(distinct at.safe_transactions) = 0
